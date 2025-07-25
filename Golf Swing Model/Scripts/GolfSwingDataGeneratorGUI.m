function GolfSwingDataGeneratorGUI()
% GolfSwingDataGeneratorGUI.m
% User-friendly GUI for golf swing training data generation

% Create main figure
fig = figure('Name', 'Golf Swing Training Data Generator', ...
    'Position', [100, 100, 900, 700], ...
    'MenuBar', 'none', ...
    'ToolBar', 'none', ...
    'Resize', 'on', ...
    'NumberTitle', 'off');

% Main panel
main_panel = uipanel('Parent', fig, ...
    'Title', 'Configuration', ...
    'Position', [0.02, 0.02, 0.96, 0.96], ...
    'FontSize', 12, ...
    'FontWeight', 'bold');

% Trial Settings Panel
trial_panel = uipanel('Parent', main_panel, ...
    'Title', 'Trial Settings', ...
    'Position', [0.02, 0.75, 0.48, 0.23], ...
    'FontSize', 10);

% Number of trials
uicontrol('Parent', trial_panel, 'Style', 'text', ...
    'String', 'Number of Trials:', ...
    'Position', [10, 120, 100, 20], ...
    'HorizontalAlignment', 'left');
num_trials_edit = uicontrol('Parent', trial_panel, 'Style', 'edit', ...
    'String', '10', ...
    'Position', [120, 120, 80, 25]);

% Simulation duration
uicontrol('Parent', trial_panel, 'Style', 'text', ...
    'String', 'Duration (s):', ...
    'Position', [10, 85, 100, 20], ...
    'HorizontalAlignment', 'left');
duration_edit = uicontrol('Parent', trial_panel, 'Style', 'edit', ...
    'String', '0.3', ...
    'Position', [120, 85, 80, 25]);

% Sample rate
uicontrol('Parent', trial_panel, 'Style', 'text', ...
    'String', 'Sample Rate (Hz):', ...
    'Position', [10, 50, 100, 20], ...
    'HorizontalAlignment', 'left');
sample_rate_edit = uicontrol('Parent', trial_panel, 'Style', 'edit', ...
    'String', '100', ...
    'Position', [120, 50, 80, 25]);

% Execution mode
uicontrol('Parent', trial_panel, 'Style', 'text', ...
    'String', 'Execution Mode:', ...
    'Position', [10, 15, 100, 20], ...
    'HorizontalAlignment', 'left');
execution_popup = uicontrol('Parent', trial_panel, 'Style', 'popupmenu', ...
    'String', {'Sequential (stable)', 'Parallel (faster)'}, ...
    'Position', [120, 15, 120, 25], ...
    'Value', 1);

% Data Sources Panel
data_panel = uipanel('Parent', main_panel, ...
    'Title', 'Data Sources', ...
    'Position', [0.52, 0.75, 0.46, 0.23], ...
    'FontSize', 10);

% Data source checkboxes
logsout_check = uicontrol('Parent', data_panel, 'Style', 'checkbox', ...
    'String', 'Logsout Data', ...
    'Position', [10, 120, 120, 20], ...
    'Value', 1);

signal_bus_check = uicontrol('Parent', data_panel, 'Style', 'checkbox', ...
    'String', 'Signal Bus Data', ...
    'Position', [10, 85, 120, 20], ...
    'Value', 1);

simscape_check = uicontrol('Parent', data_panel, 'Style', 'checkbox', ...
    'String', 'Simscape Results', ...
    'Position', [10, 50, 120, 20], ...
    'Value', 1);

model_workspace_check = uicontrol('Parent', data_panel, 'Style', 'checkbox', ...
    'String', 'Model Workspace', ...
    'Position', [10, 15, 120, 20], ...
    'Value', 1);

% Modeling Mode Panel
mode_panel = uipanel('Parent', main_panel, ...
    'Title', 'Modeling Mode & Torque Scenarios', ...
    'Position', [0.02, 0.5, 0.96, 0.23], ...
    'FontSize', 10);

% Modeling mode selection (always 3 for hex polynomial)
uicontrol('Parent', mode_panel, 'Style', 'text', ...
    'String', 'Modeling Mode:', ...
    'Position', [10, 120, 100, 20], ...
    'HorizontalAlignment', 'left');
modeling_mode_text = uicontrol('Parent', mode_panel, 'Style', 'text', ...
    'String', 'Mode 3 (Hex Polynomial)', ...
    'Position', [120, 120, 200, 20], ...
    'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.9, 0.9, 0.9]);

% Torque scenario selection
uicontrol('Parent', mode_panel, 'Style', 'text', ...
    'String', 'Torque Scenario:', ...
    'Position', [10, 85, 100, 20], ...
    'HorizontalAlignment', 'left');
torque_scenario_popup = uicontrol('Parent', mode_panel, 'Style', 'popupmenu', ...
    'String', {'Variable Torques (A-G varied)', 'Zero Torque (all = 0)', 'Constant Torque (A-F=0, G=const)'}, ...
    'Position', [120, 85, 250, 25], ...
    'Value', 1);

% Constant torque value (for constant scenario)
uicontrol('Parent', mode_panel, 'Style', 'text', ...
    'String', 'Constant Value (G):', ...
    'Position', [10, 50, 120, 20], ...
    'HorizontalAlignment', 'left');
constant_value_edit = uicontrol('Parent', mode_panel, 'Style', 'edit', ...
    'String', '10', ...
    'Position', [120, 50, 80, 25]);

% Coefficient range for variable scenario
uicontrol('Parent', mode_panel, 'Style', 'text', ...
    'String', 'Coeff Range (±):', ...
    'Position', [220, 50, 100, 20], ...
    'HorizontalAlignment', 'left');
coeff_range_edit = uicontrol('Parent', mode_panel, 'Style', 'edit', ...
    'String', '50', ...
    'Position', [320, 50, 80, 25]);

% Model selection
uicontrol('Parent', mode_panel, 'Style', 'text', ...
    'String', 'Model:', ...
    'Position', [10, 15, 50, 20], ...
    'HorizontalAlignment', 'left');
model_edit = uicontrol('Parent', mode_panel, 'Style', 'edit', ...
    'String', 'GolfSwing3D_Kinetic', ...
    'Position', [70, 15, 150, 25]);

% Output Settings Panel
output_panel = uipanel('Parent', main_panel, ...
    'Title', 'Output Settings', ...
    'Position', [0.02, 0.25, 0.96, 0.23], ...
    'FontSize', 10);

% Output folder
uicontrol('Parent', output_panel, 'Style', 'text', ...
    'String', 'Output Folder:', ...
    'Position', [10, 120, 80, 20], ...
    'HorizontalAlignment', 'left');
output_folder_edit = uicontrol('Parent', output_panel, 'Style', 'edit', ...
    'String', pwd, ...
    'Position', [100, 120, 300, 25]);

% Browse button
browse_btn = uicontrol('Parent', output_panel, 'Style', 'pushbutton', ...
    'String', 'Browse...', ...
    'Position', [410, 120, 60, 25], ...
    'Callback', @browse_folder);

% Folder name
uicontrol('Parent', output_panel, 'Style', 'text', ...
    'String', 'Folder Name:', ...
    'Position', [10, 85, 80, 20], ...
    'HorizontalAlignment', 'left');
folder_name_edit = uicontrol('Parent', output_panel, 'Style', 'edit', ...
    'String', 'training_data_csv', ...
    'Position', [100, 85, 200, 25]);

% Progress Panel
progress_panel = uipanel('Parent', main_panel, ...
    'Title', 'Progress', ...
    'Position', [0.02, 0.05, 0.96, 0.18], ...
    'FontSize', 10);

% Progress bar
progress_bar = uicontrol('Parent', progress_panel, 'Style', 'text', ...
    'String', 'Ready to start...', ...
    'Position', [10, 120, 860, 25], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', 10);

% Status text
status_text = uicontrol('Parent', progress_panel, 'Style', 'text', ...
    'String', '', ...
    'Position', [10, 90, 860, 25], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', 9);

% Log text area
log_text = uicontrol('Parent', progress_panel, 'Style', 'listbox', ...
    'String', {}, ...
    'Position', [10, 10, 860, 75], ...
    'FontSize', 8);

% Control Buttons
button_panel = uipanel('Parent', main_panel, ...
    'Position', [0.02, 0.02, 0.96, 0.02]);

% Start button
start_btn = uicontrol('Parent', fig, 'Style', 'pushbutton', ...
    'String', 'Start Generation', ...
    'Position', [20, 10, 120, 40], ...
    'FontSize', 12, ...
    'FontWeight', 'bold', ...
    'BackgroundColor', [0.2, 0.8, 0.2], ...
    'Callback', @start_generation);

% Stop button
stop_btn = uicontrol('Parent', fig, 'Style', 'pushbutton', ...
    'String', 'Stop', ...
    'Position', [150, 10, 80, 40], ...
    'FontSize', 12, ...
    'FontWeight', 'bold', ...
    'BackgroundColor', [0.8, 0.2, 0.2], ...
    'Enable', 'off', ...
    'Callback', @stop_generation);

% Clear log button
clear_log_btn = uicontrol('Parent', fig, 'Style', 'pushbutton', ...
    'String', 'Clear Log', ...
    'Position', [240, 10, 80, 40], ...
    'FontSize', 10, ...
    'Callback', @clear_log);

% Store handles in figure
handles = struct();
handles.num_trials_edit = num_trials_edit;
handles.duration_edit = duration_edit;
handles.sample_rate_edit = sample_rate_edit;
handles.execution_popup = execution_popup;
handles.logsout_check = logsout_check;
handles.signal_bus_check = signal_bus_check;
handles.simscape_check = simscape_check;
handles.model_workspace_check = model_workspace_check;
handles.torque_scenario_popup = torque_scenario_popup;
handles.constant_value_edit = constant_value_edit;
handles.coeff_range_edit = coeff_range_edit;
handles.model_edit = model_edit;
handles.output_folder_edit = output_folder_edit;
handles.folder_name_edit = folder_name_edit;
handles.progress_bar = progress_bar;
handles.status_text = status_text;
handles.log_text = log_text;
handles.start_btn = start_btn;
handles.stop_btn = stop_btn;
handles.fig = fig;

% Store state
handles.is_running = false;
handles.should_stop = false;

% Store handles in figure
guidata(fig, handles);

% Callback functions
function browse_folder(~, ~)
    handles = guidata(fig);
    folder = uigetdir(get(handles.output_folder_edit, 'String'), 'Select Output Folder');
    if folder ~= 0
        set(handles.output_folder_edit, 'String', folder);
    end
end

function start_generation(~, ~)
    handles = guidata(fig);
    
    % Validate inputs
    try
        num_trials = str2double(get(handles.num_trials_edit, 'String'));
        duration = str2double(get(handles.duration_edit, 'String'));
        sample_rate = str2double(get(handles.sample_rate_edit, 'String'));
        constant_value = str2double(get(handles.constant_value_edit, 'String'));
        coeff_range = str2double(get(handles.coeff_range_edit, 'String'));
        
        if isnan(num_trials) || num_trials <= 0
            error('Invalid number of trials');
        end
        if isnan(duration) || duration <= 0
            error('Invalid duration');
        end
        if isnan(sample_rate) || sample_rate <= 0
            error('Invalid sample rate');
        end
        if isnan(constant_value)
            error('Invalid constant value');
        end
        if isnan(coeff_range) || coeff_range <= 0
            error('Invalid coefficient range');
        end
        
        % Get configuration
        config = struct();
        config.num_simulations = num_trials;
        config.simulation_time = duration;
        config.sample_rate = sample_rate;
        config.model_name = get(handles.model_edit, 'String');
        config.output_folder = get(handles.output_folder_edit, 'String');
        config.folder_name = get(handles.folder_name_edit, 'String');
        
        % Execution mode
        exec_modes = {'sequential', 'parallel'};
        config.execution_mode = exec_modes{get(handles.execution_popup, 'Value')};
        
        % Data sources
        config.use_logsout = get(handles.logsout_check, 'Value');
        config.use_signal_bus = get(handles.signal_bus_check, 'Value');
        config.use_simscape = get(handles.simscape_check, 'Value');
        config.use_model_workspace = get(handles.model_workspace_check, 'Value');
        
        % Modeling configuration
        config.modeling_mode = 3; % Always use mode 3 for hex polynomial
        config.torque_scenario = get(handles.torque_scenario_popup, 'Value');
        config.constant_value = constant_value;
        config.coeff_range = coeff_range;
        
        % Validate at least one data source is selected
        if ~config.use_logsout && ~config.use_signal_bus && ~config.use_simscape && ~config.use_model_workspace
            error('Please select at least one data source');
        end
        
        % Create output folder
        output_path = fullfile(config.output_folder, config.folder_name);
        if ~exist(output_path, 'dir')
            mkdir(output_path);
        end
        config.output_folder = output_path;
        
        % Update UI state
        set(handles.start_btn, 'Enable', 'off');
        set(handles.stop_btn, 'Enable', 'on');
        handles.is_running = true;
        handles.should_stop = false;
        guidata(fig, handles);
        
        % Start generation in background
        update_log('Starting generation...', handles);
        update_progress('Initializing...', handles);
        
        % Run generation
        run_generation(config, handles);
        
    catch ME
        errordlg(['Configuration error: ' ME.message], 'Error');
        update_log(['Error: ' ME.message], handles);
    end
end

function stop_generation(~, ~)
    handles = guidata(fig);
    handles.should_stop = true;
    guidata(fig, handles);
    update_log('Stopping generation...', handles);
end

function clear_log(~, ~)
    handles = guidata(fig);
    set(handles.log_text, 'String', {});
end

function update_log(message, handles)
    current_log = get(handles.log_text, 'String');
    timestamp = datestr(now, 'HH:MM:SS');
    new_entry = [timestamp ': ' message];
    current_log{end+1} = new_entry;
    set(handles.log_text, 'String', current_log);
    set(handles.log_text, 'Value', length(current_log));
    drawnow;
end

function update_progress(message, handles)
    set(handles.progress_bar, 'String', message);
    drawnow;
end

function update_status(message, handles)
    set(handles.status_text, 'String', message);
    drawnow;
end

function run_generation(config, handles)
    try
        update_log('Configuration validated successfully', handles);
        update_log(sprintf('Trials: %d, Duration: %.2fs, Sample Rate: %d Hz', ...
            config.num_simulations, config.simulation_time, config.sample_rate), handles);
        update_log(sprintf('Model: %s, Mode: %d', config.model_name, config.modeling_mode), handles);
        
        % Log torque scenario
        scenarios = {'Variable Torques', 'Zero Torque', 'Constant Torque'};
        update_log(sprintf('Torque Scenario: %s', scenarios{config.torque_scenario}), handles);
        
        update_log(sprintf('Output: %s', config.output_folder), handles);
        
        % Initialize results
        results = cell(config.num_simulations, 1);
        successful_trials = 0;
        failed_trials = 0;
        
        % Setup execution mode
        if strcmp(config.execution_mode, 'parallel')
            update_log('Setting up parallel computing...', handles);
            try
                if isempty(gcp('nocreate'))
                    parpool('local');
                end
                update_log('Parallel computing enabled', handles);
            catch ME
                update_log(['Warning: Could not setup parallel computing: ' ME.message], handles);
                update_log('Falling back to sequential execution', handles);
                config.execution_mode = 'sequential';
            end
        end
        
        % Run trials sequentially (parallel execution disabled for now)
        update_log('Running trials sequentially...', handles);
        for sim_idx = 1:config.num_simulations
            if handles.should_stop
                update_log('Generation stopped by user', handles);
                break;
            end
            
            % Update progress
            progress = (sim_idx - 1) / config.num_simulations * 100;
            update_progress(sprintf('Trial %d/%d (%.1f%%)', sim_idx, config.num_simulations, progress), handles);
            update_status(sprintf('Processing trial %d...', sim_idx), handles);
            
            try
                result = run_single_trial(sim_idx, config);
                results{sim_idx} = result;
                
                if result.success
                    successful_trials = successful_trials + 1;
                    update_log(sprintf('Trial %d: Success (%d rows, %d columns)', ...
                        sim_idx, result.data_points, result.columns), handles);
                else
                    failed_trials = failed_trials + 1;
                    update_log(sprintf('Trial %d: Failed - %s', sim_idx, result.error), handles);
                end
                
            catch ME
                failed_trials = failed_trials + 1;
                results{sim_idx} = struct('success', false, 'error', ME.message);
                update_log(sprintf('Trial %d: Error - %s', sim_idx, ME.message), handles);
            end
        end
        
        % Final summary
        update_progress('Generation complete', handles);
        update_status(sprintf('Success: %d, Failed: %d', successful_trials, failed_trials), handles);
        update_log(sprintf('Generation complete. Success: %d, Failed: %d', successful_trials, failed_trials), handles);
        
        if successful_trials > 0
            update_log(sprintf('Files saved to: %s', config.output_folder), handles);
        end
        
    catch ME
        update_log(['Generation error: ' ME.message], handles);
        update_progress('Generation failed', handles);
    end
    
    % Reset UI state
    handles = guidata(fig);
    handles.is_running = false;
    set(handles.start_btn, 'Enable', 'on');
    set(handles.stop_btn, 'Enable', 'off');
    guidata(fig, handles);
end

function result = run_single_trial(sim_idx, config)
    % Generate polynomial coefficients based on scenario
    polynomial_coeffs = generatePolynomialCoefficients(config);
    
    % Create simulation input
    simInput = Simulink.SimulationInput(config.model_name);
    simInput = simInput.setModelParameter('StopTime', num2str(config.simulation_time));
    
    % Set modeling mode to 3 (hex polynomial)
    simInput = simInput.setVariable('ModelingMode', Simulink.Parameter(config.modeling_mode));
    
    % Set polynomial coefficients
    simInput = setPolynomialVariables(simInput, polynomial_coeffs);
    
    % Configure logging
    simInput = simInput.setModelParameter('SignalLogging', 'on');
    simInput = simInput.setModelParameter('SignalLoggingName', 'out');
    simInput = simInput.setModelParameter('SignalLoggingSaveFormat', 'Dataset');
    
    % Run simulation
    simOut = sim(simInput);
    
    % Extract data based on selected sources
    [trial_data, signal_names] = extractCompleteTrialData(simOut, sim_idx, config);
    
    if ~isempty(trial_data)
        % Create CSV file
        data_table = array2table(trial_data, 'VariableNames', signal_names);
        timestamp = datestr(now, 'yyyymmdd_HHMMSS');
        filename = sprintf('trial_%03d_%s.csv', sim_idx, timestamp);
        filepath = fullfile(config.output_folder, filename);
        writetable(data_table, filepath);
        
        result = struct();
        result.success = true;
        result.filename = filename;
        result.data_points = size(trial_data, 1);
        result.columns = size(trial_data, 2);
    else
        result = struct();
        result.success = false;
        result.error = 'No data extracted';
    end
end

function coeffs = generatePolynomialCoefficients(config)
    % Define all joint coefficient names based on the model
    joint_coeffs = {
        % Hip torques
        {'HipInputXA', 'HipInputXB', 'HipInputXC', 'HipInputXD', 'HipInputXE', 'HipInputXF', 'HipInputXG'};
        {'HipInputYA', 'HipInputYB', 'HipInputYC', 'HipInputYD', 'HipInputYE', 'HipInputYF', 'HipInputYG'};
        {'HipInputZA', 'HipInputZB', 'HipInputZC', 'HipInputZD', 'HipInputZE', 'HipInputZF', 'HipInputZG'};
        % Spine torques
        {'SpineInputXA', 'SpineInputXB', 'SpineInputXC', 'SpineInputXD', 'SpineInputXE', 'SpineInputXF', 'SpineInputXG'};
        {'SpineInputYA', 'SpineInputYB', 'SpineInputYC', 'SpineInputYD', 'SpineInputYE', 'SpineInputYF', 'SpineInputYG'};
        % Left shoulder
        {'LScapInputXA', 'LScapInputXB', 'LScapInputXC', 'LScapInputXD', 'LScapInputXE', 'LScapInputXF', 'LScapInputXG'};
        {'LScapInputYA', 'LScapInputYB', 'LScapInputYC', 'LScapInputYD', 'LScapInputYE', 'LScapInputYF', 'LScapInputYG'};
        % Left arm
        {'LSInputXA', 'LSInputXB', 'LSInputXC', 'LSInputXD', 'LSInputXE', 'LSInputXF', 'LSInputXG'};
        {'LSInputYA', 'LSInputYB', 'LSInputYC', 'LSInputYD', 'LSInputYE', 'LSInputYF', 'LSInputYG'};
        {'LSInputZA', 'LSInputZB', 'LSInputZC', 'LSInputZD', 'LSInputZE', 'LSInputZF', 'LSInputZG'};
        % Right shoulder
        {'RScapInputXA', 'RScapInputXB', 'RScapInputXC', 'RScapInputXD', 'RScapInputXE', 'RScapInputXF', 'RScapInputXG'};
        {'RScapInputYA', 'RScapInputYB', 'RScapInputYC', 'RScapInputYD', 'RScapInputYE', 'RScapInputYF', 'RScapInputYG'};
        % Right arm
        {'RSInputXA', 'RSInputXB', 'RSInputXC', 'RSInputXD', 'RSInputXE', 'RSInputXF', 'RSInputXG'};
        {'RSInputYA', 'RSInputYB', 'RSInputYC', 'RSInputYD', 'RSInputYE', 'RSInputYF', 'RSInputYG'};
        {'RSInputZA', 'RSInputZB', 'RSInputZC', 'RSInputZD', 'RSInputZE', 'RSInputZF', 'RSInputZG'};
        % Left elbow
        {'LEInputA', 'LEInputB', 'LEInputC', 'LEInputD', 'LEInputE', 'LEInputF', 'LEInputG'};
        % Right elbow
        {'REInputA', 'REInputB', 'REInputC', 'REInputD', 'REInputE', 'REInputF', 'REInputG'};
        % Left wrist
        {'LWInputXA', 'LWInputXB', 'LWInputXC', 'LWInputXD', 'LWInputXE', 'LWInputXF', 'LWInputXG'};
        {'LWInputYA', 'LWInputYB', 'LWInputYC', 'LWInputYD', 'LWInputYE', 'LWInputYF', 'LWInputYG'};
        % Right wrist
        {'RWInputXA', 'RWInputXB', 'RWInputXC', 'RWInputXD', 'RWInputXE', 'RWInputXF', 'RWInputXG'};
        {'RWInputYA', 'RWInputYB', 'RWInputYC', 'RWInputYD', 'RWInputYE', 'RWInputYF', 'RWInputYG'};
        % Left leg
        {'LEInputA', 'LEInputB', 'LEInputC', 'LEInputD', 'LEInputE', 'LEInputF', 'LEInputG'};
        % Right leg
        {'REInputA', 'REInputB', 'REInputC', 'REInputD', 'REInputE', 'REInputF', 'REInputG'};
        % Left foot
        {'LFInputA', 'LFInputB', 'LFInputC', 'LFInputD', 'LFInputE', 'LFInputF', 'LFInputG'};
        % Right foot
        {'RFInputA', 'RFInputB', 'RFInputC', 'RFInputD', 'RFInputE', 'RFInputF', 'RFInputG'};
    };
    
    coeffs = struct();
    
    for i = 1:length(joint_coeffs)
        joint_set = joint_coeffs{i};
        for j = 1:length(joint_set)
            coeff_name = joint_set{j};
            
            switch config.torque_scenario
                case 1 % Variable torques (A-G varied)
                    coeffs.(coeff_name) = (rand(1) - 0.5) * 2 * config.coeff_range;
                case 2 % Zero torque (all = 0)
                    coeffs.(coeff_name) = 0;
                case 3 % Constant torque (A-F=0, G=const)
                    if j == 7 % G coefficient
                        coeffs.(coeff_name) = config.constant_value;
                    else % A-F coefficients
                        coeffs.(coeff_name) = 0;
                    end
            end
        end
    end
end

function simInput = setPolynomialVariables(simInput, coeffs)
    fields = fieldnames(coeffs);
    for i = 1:length(fields)
        field_name = fields{i};
        coeff_values = coeffs.(field_name);
        simInput = simInput.setVariable(field_name, Simulink.Parameter(coeff_values));
    end
end

function [trial_data, signal_names] = extractCompleteTrialData(simOut, sim_idx, config)
    try
        % Get time vector and resample to target sample rate
        time_vector = simOut.tout;
        if isempty(time_vector)
            trial_data = [];
            signal_names = {};
            return;
        end
        
        % Resample to target sample rate
        target_time = 0:1/config.sample_rate:config.simulation_time;
        target_time = target_time(target_time <= config.simulation_time);
        
        % Initialize data matrix and signal names
        num_time_points = length(target_time);
        trial_data = zeros(num_time_points, 0);
        signal_names = {'time', 'simulation_id'};
        
        % Add time and simulation ID
        [trial_data, signal_names, success] = addColumnSafely(trial_data, signal_names, target_time, 'time');
        [trial_data, signal_names, success] = addColumnSafely(trial_data, signal_names, repmat(sim_idx, num_time_points, 1), 'simulation_id');
        
        % Extract data based on selected sources
        if config.use_model_workspace
            [trial_data, signal_names] = extractModelWorkspaceData(config.model_name, trial_data, signal_names, num_time_points);
        end
        
        if config.use_logsout
            [trial_data, signal_names] = extractLogsoutData(simOut, trial_data, signal_names, target_time);
        end
        
        if config.use_signal_bus
            [trial_data, signal_names] = extractSignalLogStructs(simOut, trial_data, signal_names, target_time);
        end
        
        if config.use_simscape
            [trial_data, signal_names] = extractSimscapeResultsData(simOut, trial_data, signal_names, target_time);
        end
        
        % Filter and clean up
        [trial_data, signal_names] = filterDiscreteVariables(trial_data, signal_names);
        signal_names = makeUniqueColumnNames(signal_names);
        
        % Final validation
        if size(trial_data, 2) ~= length(signal_names)
            min_length = min(size(trial_data, 2), length(signal_names));
            trial_data = trial_data(:, 1:min_length);
            signal_names = signal_names(1:min_length);
        end
        
    catch ME
        trial_data = [];
        signal_names = {};
    end
end

% Include helper functions from GolfSwingDataGeneratorHelpers.m
% These functions are defined in the separate helper file
end 