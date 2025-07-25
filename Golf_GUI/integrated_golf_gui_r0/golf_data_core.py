#!/usr/bin/env python3
"""
Golf Swing Visualizer - Core Data Structures and Processing
High-performance data handling with optimized MATLAB loading and frame processing
"""

import numpy as np
import pandas as pd
import scipy.io
from dataclasses import dataclass, field
from typing import Dict, List, Optional, Tuple, Union
from numba import jit, njit
import warnings
import time
from pathlib import Path
from golf_inverse_dynamics import (
    calculate_inverse_dynamics, 
    butter_lowpass_filter, 
    savitzky_golay_filter
)

# ============================================================================
# OPTIMIZED DATA STRUCTURES
# ============================================================================

@dataclass
class FrameData:
    """Optimized frame data structure with validation"""
    frame_idx: int
    time: float
    
    # Body points (all as numpy arrays for vectorized operations)
    butt: np.ndarray = field(default_factory=lambda: np.zeros(3, dtype=np.float32))
    clubhead: np.ndarray = field(default_factory=lambda: np.zeros(3, dtype=np.float32))
    midpoint: np.ndarray = field(default_factory=lambda: np.zeros(3, dtype=np.float32))
    left_wrist: np.ndarray = field(default_factory=lambda: np.zeros(3, dtype=np.float32))
    left_elbow: np.ndarray = field(default_factory=lambda: np.zeros(3, dtype=np.float32))
    left_shoulder: np.ndarray = field(default_factory=lambda: np.zeros(3, dtype=np.float32))
    right_wrist: np.ndarray = field(default_factory=lambda: np.zeros(3, dtype=np.float32))
    right_elbow: np.ndarray = field(default_factory=lambda: np.zeros(3, dtype=np.float32))
    right_shoulder: np.ndarray = field(default_factory=lambda: np.zeros(3, dtype=np.float32))
    hub: np.ndarray = field(default_factory=lambda: np.zeros(3, dtype=np.float32))
    
    # Force/torque vectors for each dataset
    forces: Dict[str, np.ndarray] = field(default_factory=dict)
    torques: Dict[str, np.ndarray] = field(default_factory=dict)
    
    # Derived properties
    shaft_vector: np.ndarray = field(default_factory=lambda: np.zeros(3, dtype=np.float32))
    shaft_length: float = 0.0
    face_normal: np.ndarray = field(default_factory=lambda: np.array([1, 0, 0], dtype=np.float32))
    
    def __post_init__(self):
        """Calculate derived properties after initialization"""
        self._calculate_shaft_properties()
        self._ensure_data_types()
    
    def _calculate_shaft_properties(self):
        """Calculate shaft vector, length and ensure proper types"""
        if np.isfinite([self.butt, self.clubhead]).all():
            self.shaft_vector = self.clubhead - self.butt
            self.shaft_length = np.linalg.norm(self.shaft_vector)
        else:
            self.shaft_vector = np.array([0, 0, 1], dtype=np.float32)
            self.shaft_length = 1.0
    
    def _ensure_data_types(self):
        """Ensure all arrays are float32 for OpenGL compatibility"""
        for attr_name in ['butt', 'clubhead', 'midpoint', 'left_wrist', 'left_elbow', 
                         'left_shoulder', 'right_wrist', 'right_elbow', 'right_shoulder', 'hub']:
            attr = getattr(self, attr_name)
            if attr.dtype != np.float32:
                setattr(self, attr_name, attr.astype(np.float32))
    
    @property
    def is_valid(self) -> bool:
        """Check if frame data is valid (no NaN/Inf in critical points)"""
        critical_points = [self.butt, self.clubhead, self.midpoint]
        return all(np.isfinite(point).all() for point in critical_points)
    
    @property
    def shaft_direction(self) -> np.ndarray:
        """Get normalized shaft direction vector"""
        if self.shaft_length > 1e-6:
            return self.shaft_vector / self.shaft_length
        return np.array([0, 0, 1], dtype=np.float32)

@dataclass
class RenderConfig:
    """Complete rendering configuration with performance optimizations"""
    # Visibility toggles
    show_forces: Dict[str, bool] = field(default_factory=lambda: {
        'BASEQ': True, 'ZTCFQ': True, 'DELTAQ': True
    })
    show_torques: Dict[str, bool] = field(default_factory=lambda: {
        'BASEQ': True, 'ZTCFQ': True, 'DELTAQ': True
    })
    show_body_segments: Dict[str, bool] = field(default_factory=lambda: {
        'left_forearm': True, 'left_upper_arm': True,
        'right_forearm': True, 'right_upper_arm': True,
        'left_shoulder_neck': True, 'right_shoulder_neck': True
    })
    
    # Core visibility
    show_club: bool = True
    show_face_normal: bool = True
    show_ground: bool = True
    show_ball: bool = True
    show_trajectory: bool = False
    show_coordinate_system: bool = False
    
    # Visual parameters
    vector_scale: float = 1.0
    body_opacity: float = 0.85
    force_opacity: float = 0.9
    lighting_intensity: float = 1.0
    ambient_strength: float = 0.3

    # Calculated dynamics visualization
    show_calculated_force: bool = True
    show_calculated_torque: bool = True
    calculated_vector_scale: float = 1.0
    
    # Quality settings
    body_segment_resolution: int = 16  # Cylinder segments
    sphere_resolution: int = 12
    antialiasing: bool = True
    shadows: bool = True
    
    # Animation settings
    motion_blur: bool = False
    trail_length: int = 30
    smooth_interpolation: bool = True
    
    # Performance settings
    use_instanced_rendering: bool = True
    frustum_culling: bool = True
    level_of_detail: bool = True

@dataclass
class PerformanceStats:
    """Performance monitoring structure"""
    fps: float = 0.0
    frame_time_ms: float = 0.0
    render_time_ms: float = 0.0
    data_processing_time_ms: float = 0.0
    memory_usage_mb: float = 0.0
    frame_times: List[float] = field(default_factory=list)
    
    def update_frame_time(self, frame_time: float):
        """Update frame timing statistics"""
        self.frame_times.append(frame_time)
        if len(self.frame_times) > 120:  # Keep last 2 seconds at 60fps
            self.frame_times.pop(0)
        
        if self.frame_times:
            avg_time = sum(self.frame_times) / len(self.frame_times)
            self.frame_time_ms = avg_time * 1000
            self.fps = 1.0 / avg_time if avg_time > 0 else 0

# ============================================================================
# OPTIMIZED MATLAB DATA LOADER
# ============================================================================

class MatlabDataLoader:
    """High-performance MATLAB data loader with caching and validation"""
    
    def __init__(self):
        self.cache = {}
        self.load_stats = {}
        
    def load_datasets(self, baseq_file: str, ztcfq_file: str, delta_file: str) -> Tuple[pd.DataFrame, pd.DataFrame, pd.DataFrame]:
        """Load all three MATLAB datasets with comprehensive error handling"""
        start_time = time.time()
        
        files = {
            'BASEQ': baseq_file,
            'ZTCFQ': ztcfq_file, 
            'DELTAQ': delta_file
        }
        
        datasets = {}
        
        for name, filepath in files.items():
            print(f"🔄 Loading {name} from {filepath}...")
            try:
                dataset = self._load_single_file(filepath, name)
                datasets[name] = dataset
                print(f"✅ {name}: {len(dataset)} frames loaded")
            except Exception as e:
                raise RuntimeError(f"❌ Failed to load {name} from {filepath}: {e}")
        
        # Validate consistency between datasets
        self._validate_dataset_consistency(datasets)
        
        load_time = time.time() - start_time
        print(f"📊 Total load time: {load_time:.2f}s")
        
        return datasets['BASEQ'], datasets['ZTCFQ'], datasets['DELTAQ']
    
    def _load_single_file(self, filepath: str, dataset_name: str) -> pd.DataFrame:
        """Load single MATLAB file with optimized processing"""
        if not Path(filepath).exists():
            raise FileNotFoundError(f"File not found: {filepath}")
        
        # Load MATLAB file
        mat_data = scipy.io.loadmat(filepath)
        
        # Find the table variable intelligently
        var_name = self._find_table_variable(mat_data, dataset_name)
        mat_table = mat_data[var_name]
        
        # Convert to DataFrame with optimized processing
        df = self._convert_to_dataframe(mat_table, dataset_name)
        
        return df
    
    def _find_table_variable(self, mat_data: dict, dataset_name: str) -> str:
        """Intelligently find the main table variable"""
        # Remove MATLAB system variables
        user_vars = {k: v for k, v in mat_data.items() if not k.startswith('__')}
        
        if not user_vars:
            raise ValueError(f"No user variables found in {dataset_name}")
        
        # Try common naming patterns
        candidates = [
            f'{dataset_name}_table',
            f'{dataset_name.lower()}_table', 
            dataset_name,
            dataset_name.lower(),
            f'{dataset_name}Table',
            f'{dataset_name.lower()}Table'
        ]
        
        for candidate in candidates:
            if candidate in user_vars:
                return candidate
        
        # Fallback to largest variable (likely the data table)
        largest_var = max(user_vars.keys(), key=lambda k: user_vars[k].nbytes)
        warnings.warn(f"Using fallback variable '{largest_var}' for {dataset_name}")
        return largest_var
    
    def _convert_to_dataframe(self, mat_table: np.ndarray, dataset_name: str) -> pd.DataFrame:
        """Convert MATLAB table to optimized pandas DataFrame"""
        if not hasattr(mat_table, 'dtype') or mat_table.dtype.names is None:
            raise ValueError(f"Invalid MATLAB table structure in {dataset_name}")
        
        column_names = list(mat_table.dtype.names)
        num_rows = len(mat_table)
        
        # Special handling for vector columns
        vector_columns = ['TotalHandForceGlobal', 'EquivalentMidpointCoupleGlobal']
        
        df_data = {}
        
        for col in column_names:
            col_data = mat_table[col]
            
            if col in vector_columns:
                # Handle 3D vector data specially
                df_data[col] = self._process_vector_column(col_data, col, num_rows)
            else:
                # Handle scalar/other data
                df_data[col] = self._process_scalar_column(col_data, col, num_rows)
        
        df = pd.DataFrame(df_data)
        
        # Validate essential columns
        self._validate_dataframe(df, dataset_name)
        
        return df
    
    def _process_vector_column(self, col_data: np.ndarray, col_name: str, num_rows: int) -> List[np.ndarray]:
        """Process 3D vector columns with comprehensive error handling"""
        processed_vectors = []
        
        for i in range(num_rows):
            try:
                if col_data.dtype == 'object':
                    # Handle cell array format
                    cell_data = col_data[i, 0] if col_data.ndim > 1 else col_data[i]
                    if hasattr(cell_data, 'flatten'):
                        vector = cell_data.flatten()
                    else:
                        vector = np.array(cell_data).flatten()
                else:
                    # Handle numeric array format
                    if col_data.ndim == 2 and col_data.shape[1] == 3:
                        vector = col_data[i, :]
                    else:
                        vector = col_data[i].flatten()
                
                # Ensure 3D vector
                if len(vector) >= 3:
                    processed_vectors.append(vector[:3].astype(np.float32))
                else:
                    processed_vectors.append(np.zeros(3, dtype=np.float32))
                    warnings.warn(f"Invalid vector at row {i} in {col_name}, using zeros")
                    
            except Exception as e:
                processed_vectors.append(np.zeros(3, dtype=np.float32))
                warnings.warn(f"Error processing vector at row {i} in {col_name}: {e}")
        
        return processed_vectors
    
    def _process_scalar_column(self, col_data: np.ndarray, col_name: str, num_rows: int) -> np.ndarray:
        """Process scalar columns with type optimization"""
        try:
            if col_data.dtype == 'object':
                # Handle cell arrays
                processed = []
                for i in range(num_rows):
                    cell = col_data[i, 0] if col_data.ndim > 1 else col_data[i]
                    if hasattr(cell, 'item'):
                        processed.append(cell.item())
                    else:
                        processed.append(float(cell) if cell is not None else 0.0)
                return np.array(processed, dtype=np.float32)
            else:
                # Handle numeric arrays
                flattened = col_data.flatten()
                if len(flattened) == num_rows:
                    return flattened.astype(np.float32)
                else:
                    warnings.warn(f"Dimension mismatch in {col_name}, padding with zeros")
                    result = np.zeros(num_rows, dtype=np.float32)
                    result[:min(len(flattened), num_rows)] = flattened[:num_rows]
                    return result
        except Exception as e:
            warnings.warn(f"Error processing scalar column {col_name}: {e}")
            return np.zeros(num_rows, dtype=np.float32)
    
    def _validate_dataframe(self, df: pd.DataFrame, dataset_name: str):
        """Validate DataFrame has required columns and data"""
        required_columns = [
            'Butt', 'Clubhead', 'MidPoint',
            'LeftWrist', 'LeftElbow', 'LeftShoulder',
            'RightWrist', 'RightElbow', 'RightShoulder', 'Hub',
            'TotalHandForceGlobal', 'EquivalentMidpointCoupleGlobal'
        ]
        
        missing_columns = []
        for col in required_columns:
            if col not in df.columns:
                missing_columns.append(col)
        
        if missing_columns:
            warnings.warn(f"Missing columns in {dataset_name}: {missing_columns}")
        
        if len(df) == 0:
            raise ValueError(f"No data rows in {dataset_name}")
    
    def _validate_dataset_consistency(self, datasets: Dict[str, pd.DataFrame]):
        """Validate that all datasets have consistent frame counts"""
        frame_counts = {name: len(df) for name, df in datasets.items()}
        
        if len(set(frame_counts.values())) > 1:
            warnings.warn(f"Inconsistent frame counts: {frame_counts}")
        
        min_frames = min(frame_counts.values())
        if min_frames < 2:
            raise ValueError("Need at least 2 frames for proper visualization")

# ============================================================================
# HIGH-PERFORMANCE FRAME PROCESSOR
# ============================================================================

class FrameProcessor:
    """Process and prepare raw data frames for rendering"""
    
    def __init__(self, datasets: Tuple[pd.DataFrame, pd.DataFrame, pd.DataFrame], config: RenderConfig):
        self.baseq_df, self.ztcfq_df, self.deltaq_df = datasets
        self.config = config
        self.num_frames = len(self.baseq_df)
        self.time_vector = self.baseq_df['Time'].values if 'Time' in self.baseq_df else np.arange(self.num_frames) * 0.001
        
        # Data caches
        self.raw_data_cache: Dict[int, FrameData] = {}
        self.dynamics_cache: Dict[str, Dict] = {}
        self.current_filter = 'None'
        
        # Track current frame for UI coordination
        self.current_frame = 0

    def set_filter(self, filter_type: str):
        """Set the data filter and invalidate dynamics cache."""
        if filter_type != self.current_filter:
            self.current_filter = filter_type
            self.invalidate_cache()

    def invalidate_cache(self):
        """Invalidate cached dynamics data."""
        self.dynamics_cache = {}
        print(f"Cache invalidated due to filter change to {self.current_filter}")

    def get_frame_data(self, frame_idx: int) -> FrameData:
        """Get processed frame data, including calculated dynamics."""
        # Bounds checking
        frame_idx = max(0, min(frame_idx, self.num_frames - 1))

        # Get raw data from cache or process it
        if frame_idx not in self.raw_data_cache:
            self.raw_data_cache[frame_idx] = self._process_raw_frame(frame_idx)
        frame_data = self.raw_data_cache[frame_idx]

        # Get or calculate dynamics data
        if self.current_filter not in self.dynamics_cache:
            self._calculate_dynamics_for_filter()
        
        dynamics = self.dynamics_cache[self.current_filter]
        frame_data.forces['calculated'] = dynamics['force'][frame_idx]
        frame_data.torques['calculated'] = dynamics['torque'][frame_idx]

        return frame_data

    def _calculate_dynamics_for_filter(self):
        """Calculate inverse dynamics for the entire dataset with the current filter."""
        print(f"Calculating dynamics with filter: {self.current_filter}...")
        start_time = time.time()

        # Extract full position and orientation data
        position_data = np.array([self.get_column_data(self.baseq_df, 'Clubhead', i) for i in range(self.num_frames)])
        # Placeholder for orientation data
        orientation_data = np.array([np.identity(3)] * self.num_frames)

        # Apply filter if selected
        if self.current_filter != 'None':
            fs = 1 / np.mean(np.diff(self.time_vector))
            for i in range(3): # Filter X, Y, Z components
                if self.current_filter == 'Butterworth':
                    position_data[:, i] = butter_lowpass_filter(position_data[:, i], cutoff=50, fs=fs)
                elif self.current_filter == 'Savitzky-Golay':
                    position_data[:, i] = savitzky_golay_filter(position_data[:, i])

        # Calculate dynamics
        self.dynamics_cache[self.current_filter] = calculate_inverse_dynamics(
            position_data,
            orientation_data,
            self.time_vector
        )
        
        end_time = time.time()
        print(f"Dynamics calculation took {end_time - start_time:.2f}s")

    def _process_raw_frame(self, frame_idx: int) -> FrameData:
        """Process a single frame from raw data sources."""
        frame_data = FrameData(
            frame_idx=frame_idx,
            time=self.time_vector[frame_idx],
            butt=self.get_column_data(self.baseq_df, 'Butt', frame_idx),
            clubhead=self.get_column_data(self.baseq_df, 'Clubhead', frame_idx),
            midpoint=self.get_column_data(self.baseq_df, 'MidPoint', frame_idx),
            left_wrist=self.get_column_data(self.baseq_df, 'LeftWrist', frame_idx),
            left_elbow=self.get_column_data(self.baseq_df, 'LeftElbow', frame_idx),
            left_shoulder=self.get_column_data(self.baseq_df, 'LeftShoulder', frame_idx),
            right_wrist=self.get_column_data(self.baseq_df, 'RightWrist', frame_idx),
            right_elbow=self.get_column_data(self.baseq_df, 'RightElbow', frame_idx),
            right_shoulder=self.get_column_data(self.baseq_df, 'RightShoulder', frame_idx),
            hub=self.get_column_data(self.baseq_df, 'Hub', frame_idx)
        )

        # Extract forces and torques from all datasets
        datasets = {
            'BASEQ': self.baseq_df,
            'ZTCFQ': self.ztcfq_df, 
            'DELTAQ': self.deltaq_df
        }
        
        for name, df in datasets.items():
            frame_data.forces[name] = self.get_column_data(df, 'TotalHandForceGlobal', frame_idx)
            frame_data.torques[name] = self.get_column_data(df, 'EquivalentMidpointCoupleGlobal', frame_idx)
        
        # Calculate face normal if we have previous frame
        if frame_idx > 0:
            prev_clubhead = self.get_column_data(self.baseq_df, 'Clubhead', frame_idx - 1)
            frame_data.face_normal = self._calculate_face_normal(
                frame_data.clubhead, prev_clubhead, frame_data.shaft_direction
            )
        
        return frame_data

    def get_column_data(self, df: pd.DataFrame, col_name: str, row_idx: int) -> np.ndarray:
        """Safely get data from a DataFrame column."""
        if col_name in df and row_idx < len(df):
            val = df.at[row_idx, col_name]
            if isinstance(val, np.ndarray):
                return val.astype(np.float32)
        return np.zeros(3, dtype=np.float32)

    def get_num_frames(self) -> int:
        return self.num_frames

    def get_time_vector(self) -> np.ndarray:
        return self.time_vector

    def _calculate_dynamics(self):
        """Calculate inverse dynamics for the processed data."""
        if 'GOLF_CLUB_HEAD_POS' in self.processed_data:
            pos_data = self.processed_data['GOLF_CLUB_HEAD_POS']
            # Placeholder for orientation data - assuming not available from .mat
            # A more advanced implementation would load or compute this.
            num_frames = pos_data.shape[0]
            orientation_data = np.array([np.identity(3)] * num_frames)

            self.dynamics_data = calculate_inverse_dynamics(
                pos_data,
                orientation_data,
                self.time_vector,
                club_mass=0.2,  # Example mass
                eval_offset=0.0
            )

    @staticmethod
    @njit
    def _calculate_face_normal_jit(current_clubhead: np.ndarray, previous_clubhead: np.ndarray, shaft_direction: np.ndarray) -> np.ndarray:
        """Numba-optimized face normal calculation"""
        # Velocity-based calculation
        velocity = current_clubhead - previous_clubhead
        velocity_magnitude = np.linalg.norm(velocity)
        
        if velocity_magnitude > 1e-4:
            velocity_direction = velocity / velocity_magnitude
            cross_product = np.cross(shaft_direction, velocity_direction)
            
            if np.linalg.norm(cross_product) > 1e-6:
                # Face normal is perpendicular to both shaft and velocity
                face_normal_temp = np.cross(np.cross(velocity_direction, shaft_direction), shaft_direction)
                face_normal_magnitude = np.linalg.norm(face_normal_temp)
                
                if face_normal_magnitude > 1e-6:
                    return face_normal_temp / face_normal_magnitude
        
        # Fallback: perpendicular to shaft in XY plane
        if abs(shaft_direction[2]) < 0.99:  # Not pointing straight up/down
            fallback = np.array([-shaft_direction[1], shaft_direction[0], 0.0], dtype=np.float32)
            fallback_magnitude = np.linalg.norm(fallback)
            if fallback_magnitude > 1e-6:
                return fallback / fallback_magnitude
        
        # Final fallback
        return np.array([1.0, 0.0, 0.0], dtype=np.float32)
    
    def _calculate_face_normal(self, current_clubhead: np.ndarray, previous_clubhead: np.ndarray, shaft_direction: np.ndarray) -> np.ndarray:
        """Calculate face normal using velocity-based method"""
        if np.isfinite([current_clubhead, previous_clubhead, shaft_direction]).all():
            return self._calculate_face_normal_jit(current_clubhead, previous_clubhead, shaft_direction)
        else:
            return np.array([1.0, 0.0, 0.0], dtype=np.float32)
    
    def get_frame_data(self, frame_idx: int) -> FrameData:
        """Get processed frame data with intelligent caching"""
        # Bounds checking
        frame_idx = max(0, min(frame_idx, self.num_frames - 1))
        
        # Check cache first
        if frame_idx in self.processed_data:
            return self.processed_data[frame_idx]
        
        # Process new frame
        frame_data = self._process_single_frame(frame_idx)
        
        return frame_data
    
    def get_frame_range(self, start_frame: int, end_frame: int) -> List[FrameData]:
        """Get multiple frames efficiently (for trajectory analysis)"""
        start_frame = max(0, start_frame)
        end_frame = min(self.num_frames - 1, end_frame)
        
        frames = []
        for i in range(start_frame, end_frame + 1):
            frames.append(self.get_frame_data(i))
        
        return frames

    def set_filter_type(self, filter_type: str):
        """Set the current filter type and invalidate cached filtered data"""
        self.set_filter(filter_type)  # Use existing method

    def set_filter_param(self, param_name: str, value):
        """Set a filter parameter and invalidate cached filtered data"""
        if not hasattr(self, 'filter_params'):
            self.filter_params = {}
        self.filter_params[param_name] = value
        self.invalidate_cache()

    def set_vector_visibility(self, vector_type: str, visible: bool):
        """Set visibility for calculated vector types"""
        if vector_type == "force":
            self.config.show_calculated_force = visible
        elif vector_type == "torque":
            self.config.show_calculated_torque = visible
        # Update any other vector types as needed

    def set_vector_scale(self, vector_type: str, scale: float):
        """Set scale for vector rendering"""
        if vector_type == "all":
            self.config.calculated_vector_scale = scale
        elif vector_type == "force":
            self.config.force_vector_scale = scale
        elif vector_type == "torque":
            self.config.torque_vector_scale = scale

# ============================================================================
# GEOMETRY UTILITIES
# ============================================================================

class GeometryUtils:
    """High-performance geometry calculations for 3D visualization"""
    
    @staticmethod
    @njit
    def rotation_matrix_from_vectors(vec1: np.ndarray, vec2: np.ndarray) -> np.ndarray:
        """Create rotation matrix to rotate vec1 to vec2 using Rodrigues formula"""
        # Normalize input vectors
        v1 = vec1 / np.linalg.norm(vec1)
        v2 = vec2 / np.linalg.norm(vec2)
        
        # If vectors are already aligned
        if np.allclose(v1, v2):
            return np.eye(3, dtype=np.float32)
        
        # If vectors are opposite
        if np.allclose(v1, -v2):
            # Find any perpendicular vector
            if abs(v1[0]) < 0.9:
                perpendicular = np.array([1.0, 0.0, 0.0], dtype=np.float32)
            else:
                perpendicular = np.array([0.0, 1.0, 0.0], dtype=np.float32)
            
            v = np.cross(v1, perpendicular)
            v = v / np.linalg.norm(v)
            
            # 180 degree rotation
            return 2 * np.outer(v, v) - np.eye(3, dtype=np.float32)
        
        # General case using Rodrigues formula
        v = np.cross(v1, v2)
        s = np.linalg.norm(v)
        c = np.dot(v1, v2)
        
        vx = np.array([[0, -v[2], v[1]],
                      [v[2], 0, -v[0]], 
                      [-v[1], v[0], 0]], dtype=np.float32)
        
        R = np.eye(3, dtype=np.float32) + vx + np.dot(vx, vx) * ((1 - c) / (s * s))
        
        return R
    
    @staticmethod
    def create_cylinder_mesh(radius: float = 1.0, height: float = 1.0, segments: int = 16) -> Tuple[np.ndarray, np.ndarray, np.ndarray]:
        """Create optimized cylinder mesh with normals"""
        vertices = []
        normals = []
        indices = []
        
        # Generate vertices and normals
        for i in range(segments + 1):
            angle = 2 * np.pi * i / segments
            x, z = np.cos(angle), np.sin(angle)
            
            # Bottom vertex
            vertices.extend([x * radius, 0, z * radius])
            normals.extend([x, 0, z])
            
            # Top vertex
            vertices.extend([x * radius, height, z * radius])
            normals.extend([x, 0, z])
        
        # Generate indices for triangle strip
        for i in range(segments):
            # Two triangles per segment
            base = i * 2
            next_base = ((i + 1) % (segments + 1)) * 2
            
            # First triangle
            indices.extend([base, base + 1, next_base])
            # Second triangle  
            indices.extend([next_base, base + 1, next_base + 1])
        
        return (np.array(vertices, dtype=np.float32),
                np.array(normals, dtype=np.float32), 
                np.array(indices, dtype=np.uint32))
    
    @staticmethod
    def create_sphere_mesh(radius: float = 1.0, lat_segments: int = 12, lon_segments: int = 16) -> Tuple[np.ndarray, np.ndarray, np.ndarray]:
        """Create optimized sphere mesh using UV sphere method"""
        vertices = []
        normals = []
        indices = []
        
        # Generate vertices
        for i in range(lat_segments + 1):
            lat = np.pi * i / lat_segments - np.pi / 2  # -π/2 to π/2
            for j in range(lon_segments + 1):
                lon = 2 * np.pi * j / lon_segments  # 0 to 2π
                
                x = radius * np.cos(lat) * np.cos(lon)
                y = radius * np.sin(lat)
                z = radius * np.cos(lat) * np.sin(lon)
                
                vertices.extend([x, y, z])
                # For unit sphere, normal equals position
                normals.extend([x / radius, y / radius, z / radius])
        
        # Generate indices
        for i in range(lat_segments):
            for j in range(lon_segments):
                first = i * (lon_segments + 1) + j
                second = first + lon_segments + 1
                
                # First triangle
                indices.extend([first, second, first + 1])
                # Second triangle
                indices.extend([second, second + 1, first + 1])
        
        return (np.array(vertices, dtype=np.float32),
                np.array(normals, dtype=np.float32),
                np.array(indices, dtype=np.uint32))
    
    @staticmethod
    def create_arrow_mesh(shaft_radius: float = 0.01, shaft_length: float = 0.8, 
                         head_radius: float = 0.02, head_length: float = 0.2,
                         segments: int = 8) -> Tuple[np.ndarray, np.ndarray, np.ndarray]:
        """Create arrow mesh for force/torque visualization"""
        vertices = []
        normals = []
        indices = []
        
        # Shaft cylinder
        for i in range(segments + 1):
            angle = 2 * np.pi * i / segments
            x, z = np.cos(angle), np.sin(angle)
            
            # Bottom of shaft
            vertices.extend([x * shaft_radius, 0, z * shaft_radius])
            normals.extend([x, 0, z])
            
            # Top of shaft (where head begins)
            vertices.extend([x * shaft_radius, shaft_length, z * shaft_radius])
            normals.extend([x, 0, z])
        
        # Arrow head (cone)
        head_start_y = shaft_length
        head_end_y = shaft_length + head_length
        
        # Head base vertices
        head_base_start = len(vertices) // 3
        for i in range(segments + 1):
            angle = 2 * np.pi * i / segments
            x, z = np.cos(angle), np.sin(angle)
            
            vertices.extend([x * head_radius, head_start_y, z * head_radius])
            normals.extend([x, 0, z])  # Simplified normal
        
        # Head tip
        tip_index = len(vertices) // 3
        vertices.extend([0, head_end_y, 0])
        normals.extend([0, 1, 0])
        
        # Generate indices for shaft
        shaft_segments = segments
        for i in range(shaft_segments):
            base = i * 2
            next_base = ((i + 1) % (shaft_segments + 1)) * 2
            
            indices.extend([base, base + 1, next_base])
            indices.extend([next_base, base + 1, next_base + 1])
        
        # Generate indices for head
        for i in range(segments):
            current = head_base_start + i
            next_vertex = head_base_start + ((i + 1) % (segments + 1))
            
            indices.extend([current, tip_index, next_vertex])
        
        return (np.array(vertices, dtype=np.float32),
                np.array(normals, dtype=np.float32),
                np.array(indices, dtype=np.uint32))

# ============================================================================
# USAGE EXAMPLE AND TESTING
# ============================================================================

if __name__ == "__main__":
    # Example usage and testing
    print("🏌️ Golf Swing Visualizer - Core Data System Test")
    
    # Test geometry utilities
    print("\n🔧 Testing geometry utilities...")
    vertices, normals, indices = GeometryUtils.create_cylinder_mesh()
    print(f"   Cylinder: {len(vertices)//3} vertices, {len(indices)//3} triangles")
    
    vertices, normals, indices = GeometryUtils.create_sphere_mesh()
    print(f"   Sphere: {len(vertices)//3} vertices, {len(indices)//3} triangles")
    
    vertices, normals, indices = GeometryUtils.create_arrow_mesh()
    print(f"   Arrow: {len(vertices)//3} vertices, {len(indices)//3} triangles")
    
    # Test data structures
    print("\n📊 Testing data structures...")
    config = RenderConfig()
    stats = PerformanceStats()
    
    print(f"   RenderConfig created with {len(config.show_body_segments)} body segments")
    print(f"   Vector scale: {config.vector_scale}")
    
    # If MATLAB files are available, test loading
    try:
        loader = MatlabDataLoader()
        datasets = loader.load_datasets('BASEQ.mat', 'ZTCFQ.mat', 'DELTAQ.mat')
        
        processor = FrameProcessor(datasets)
        frame_data = processor.get_frame_data(0)
        
        print(f"\n✅ Successfully loaded and processed data:")
        print(f"   Frames: {processor.num_frames}")
        print(f"   Frame 0 valid: {frame_data.is_valid}")
        print(f"   Shaft length: {frame_data.shaft_length:.3f}")
        
    except Exception as e:
        print(f"\n📝 Note: MATLAB files not found for testing ({e})")
        print("   This is expected if running without data files")
    
    print("\n🎉 Core data system ready for integration!")
