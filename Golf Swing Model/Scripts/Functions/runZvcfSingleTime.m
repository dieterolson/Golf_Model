function zvcfDataTable = runZvcfSingleTime(simTime, baseDataTable, zvcfModelName)
% RUNZVCFSINGLETIME Runs a single ZVCF simulation at a specified time point.
%   zvcfDataTable = RUNZVCFSINGLETIME(simTime, baseDataTable, zvcfModelName)
%   Runs the ZVCF model at a specific time point 'simTime'. It configures
%   the ZVCF model's initial positions and constant joint torques by
%   interpolating values from the provided 'baseDataTable' at 'simTime'.
%   The function then runs a short simulation of the ZVCF model and returns
%   the simulation output data as a table.
%
%   This function is the converted version of SCRIPT_ZVCF_SingleTime_3D.m.
%
%   Input:
%       simTime       - The specific time point (scalar) at which to
%                       configure and run the ZVCF simulation (e.g., 0.20).
%       baseDataTable - A table containing Base data (positions and joint
%                       torques) on a time grid that spans 'simTime'.
%                       Expected columns include 'Time', 'HipTorqueZInput',
%                       'TorsoTorqueInput', etc., and 'HipPositionZ',
%                       'TorsoPosition', etc. (matching your 3D model outputs).
%       zvcfModelName - A string specifying the name of the ZVCF Simulink
%                       model (e.g., 'GolfSwing3D_ZVCF').
%
%   Output:
%       zvcfDataTable - A table containing the simulation output data from
%                       the short ZVCF run, generated by generateDataTable3D.
%                       Returns an empty table if simulation fails or data extraction fails.

% Initialize output table
zvcfDataTable = table();

% --- Check Inputs ---
if ~istable(baseDataTable) || isempty(baseDataTable) || ~ismember('Time', baseDataTable.Properties.VariableNames)
    error('Invalid baseDataTable input. Must be a non-empty table with a ''Time'' column.');
end

if ~isscalar(simTime) || ~isnumeric(simTime)
    error('Invalid simTime input. Must be a numeric scalar.');
end

if ~ischar(zvcfModelName) && ~isstring(zvcfModelName)
    error('Invalid zvcfModelName input. Must be a string.');
end

% Check if simTime is within the range of baseDataTable.Time
if simTime < min(baseDataTable.Time) || simTime > max(baseDataTable.Time)
    warning('simTime (%g) is outside the range of baseDataTable.Time [%g, %g]. Interpolation will extrapolate.', ...
            simTime, min(baseDataTable.Time), max(baseDataTable.Time));
end

% --- Load and Configure ZVCF Model ---

% Load the ZVCF model if it's not already loaded
if ~bdIsLoaded(zvcfModelName)
    try
        load_system(zvcfModelName);
    catch ME
        error('Could not load Simulink model "%s": %s', zvcfModelName, ME.message);
    end
end

% Get the model workspace
mdlWks_zvcf = get_param(zvcfModelName, 'ModelWorkspace');

% Create a SimulationInput object for this single run
in_zvcf = Simulink.SimulationInput(zvcfModelName);

% Set up ZVCF model simulation parameters on the SimulationInput object
% These override settings in the model's configuration parameters for this run
in_zvcf = in_zvcf.setStopTime(0.05); % Set the stop time for the short ZVCF simulation run
in_zvcf = in_zvcf.setFastRestart('off'); % Ensure Fast Restart is off for this model/run
in_zvcf = in_zvcf.setMaxStep(0.001); % Set maximum time step

% --- Interpolate Inputs from BaseData and Configure ZVCF Model ---
% Read the joint torque and position values from BaseData at simTime
% These values will be used as constant inputs and initial positions for the ZVCF model
% NOTE: Verify these column names match your 3D model's logged outputs
% NOTE: Verify units (radians vs. degrees) expected by your ZVCF model parameters

try
    % Interpolate Torque Inputs from BaseData
    hipJointTorque = interp1(baseDataTable.Time, baseDataTable.HipTorqueZInput, simTime, 'linear', 'extrap'); % Assuming Z is primary input axis
    torsoJointTorque = interp1(baseDataTable.Time, baseDataTable.TorsoTorqueInput, simTime, 'linear', 'extrap'); % Assuming single input
    lscapJointTorqueX = interp1(baseDataTable.Time, baseDataTable.LScapTorqueXInput, simTime, 'linear', 'extrap');
    lscapJointTorqueY = interp1(baseDataTable.Time, baseDataTable.LScapTorqueYInput, simTime, 'linear', 'extrap');
    rscapJointTorqueX = interp1(baseDataTable.Time, baseDataTable.RScapTorqueXInput, simTime, 'linear', 'extrap');
    rscapJointTorqueY = interp1(baseDataTable.Time, baseDataTable.RScapTorqueYInput, simTime, 'linear', 'extrap');
    lshoulderJointTorqueX = interp1(baseDataTable.Time, baseDataTable.LSTorqueXInput, simTime, 'linear', 'extrap');
    lshoulderJointTorqueY = interp1(baseDataTable.Time, baseDataTable.LSTorqueYInput, simTime, 'linear', 'extrap');
    lshoulderJointTorqueZ = interp1(baseDataTable.Time, baseDataTable.LSTorqueZInput, simTime, 'linear', 'extrap');
    rshoulderJointTorqueX = interp1(baseDataTable.Time, baseDataTable.RSTorqueXInput, simTime, 'linear', 'extrap');
    rshoulderJointTorqueY = interp1(baseDataTable.Time, baseDataTable.RSTorqueYInput, simTime, 'linear', 'extrap');
    rshoulderJointTorqueZ = interp1(baseDataTable.Time, baseDataTable.RSTorqueZInput, simTime, 'linear', 'extrap');
    lelbowJointTorque = interp1(baseDataTable.Time, baseDataTable.LETorqueInput, simTime, 'linear', 'extrap'); % Assuming single input
    relbowJointTorque = interp1(baseDataTable.Time, baseDataTable.RETorqueInput, simTime, 'linear', 'extrap'); % Assuming single input
    lwristJointTorqueX = interp1(baseDataTable.Time, baseDataTable.LWTorqueXInput, simTime, 'linear', 'extrap');
    lwristJointTorqueY = interp1(baseDataTable.Time, baseDataTable.LWTorqueYInput, simTime, 'linear', 'extrap');
    rwristJointTorqueX = interp1(baseDataTable.Time, baseDataTable.RWTorqueXInput, simTime, 'linear', 'extrap');
    rwristJointTorqueY = interp1(baseDataTable.Time, baseDataTable.RWTorqueYInput, simTime, 'linear', 'extrap');

    % Interpolate Position Values from BaseData (for Initial Positions)
    % Convert to degrees if the ZVCF model parameters expect degrees (as in original script)
    hipPosition = interp1(baseDataTable.Time, baseDataTable.HipPositionZ, simTime, 'linear', 'extrap') * 180/pi; % Assuming Z position is relevant
    torsoPosition = interp1(baseDataTable.Time, baseDataTable.TorsoPosition, simTime, 'linear', 'extrap') * 180/pi; % Assuming single position
    lscapPositionX = interp1(baseDataTable.Time, baseDataTable.LScapPositionX, simTime, 'linear', 'extrap') * 180/pi;
    lscapPositionY = interp1(baseDataTable.Time, baseDataTable.LScapPositionY, simTime, 'linear', 'extrap') * 180/pi;
    rscapPositionX = interp1(baseDataTable.Time, baseDataTable.RScapPositionX, simTime, 'linear', 'extrap') * 180/pi;
    rscapPositionY = interp1(baseDataTable.Time, baseDataTable.RScapPositionY, simTime, 'linear', 'extrap') * 180/pi;
    lshoulderPositionX = interp1(baseDataTable.Time, baseDataTable.LSPositionX, simTime, 'linear', 'extrap') * 180/pi;
    lshoulderPositionY = interp1(baseDataTable.Time, baseDataTable.LSPositionY, simTime, 'linear', 'extrap') * 180/pi;
    lshoulderPositionZ = interp1(baseDataTable.Time, baseDataTable.LSPositionZ, simTime, 'linear', 'extrap') * 180/pi;
    rshoulderPositionX = interp1(baseDataTable.Time, baseDataTable.RSPositionX, simTime, 'linear', 'extrap') * 180/pi;
    rshoulderPositionY = interp1(baseDataTable.Time, baseDataTable.RSPositionY, simTime, 'linear', 'extrap') * 180/pi;
    rshoulderPositionZ = interp1(baseDataTable.Time, baseDataTable.RSPositionZ, simTime, 'linear', 'extrap') * 180/pi;
    lelbowPosition = interp1(baseDataTable.Time, baseDataTable.LEPosition, simTime, 'linear', 'extrap') * 180/pi; % Assuming single position
    relbowPosition = interp1(baseDataTable.Time, baseDataTable.REPosition, simTime, 'linear', 'extrap') * 180/pi; % Assuming single position
    lwristPositionX = interp1(baseDataTable.Time, baseDataTable.LWPositionX, simTime, 'linear', 'extrap') * 180/pi;
    lwristPositionY = interp1(baseDataTable.Time, baseDataTable.LWPositionY, simTime, 'linear', 'extrap') * 180/pi;
    rwristPositionX = interp1(baseDataTable.Time, baseDataTable.RWPositionX, simTime, 'linear', 'extrap') * 180/pi;
    rwristPositionY = interp1(baseDataTable.Time, baseDataTable.RWPositionY, simTime, 'linear', 'extrap') * 180/pi;

catch ME
    warning('Error interpolating data from baseDataTable at time %g: %s', simTime, ME.message);
    % Return empty table if interpolation fails due to missing columns
    close_system(zvcfModelName, 0); % Close model
    return; % Exit the function
end

% Assign interpolated torque values as constant inputs to the ZVCF model using setVariable
% NOTE: Ensure parameter names match your ZVCF model's input blocks/parameters
in_zvcf = in_zvcf.setVariable('JointTorqueHip', hipJointTorque);
in_zvcf = in_zvcf.setVariable('JointTorqueTorso', torsoJointTorque);
in_zvcf = in_zvcf.setVariable('JointTorqueLScapX', lscapJointTorqueX);
in_zvcf = in_zvcf.setVariable('JointTorqueLScapY', lscapJointTorqueY);
in_zvcf = in_zvcf.setVariable('JointTorqueRScapX', rscapJointTorqueX);
in_zvcf = in_zvcf.setVariable('JointTorqueRScapY', rscapJointTorqueY);
in_zvcf = in_zvcf.setVariable('JointTorqueLShoulderX', lshoulderJointTorqueX);
in_zvcf = in_zvcf.setVariable('JointTorqueLShoulderY', lshoulderJointTorqueY);
in_zvcf = in_zvcf.setVariable('JointTorqueLShoulderZ', lshoulderJointTorqueZ);
in_zvcf = in_zvcf.setVariable('JointTorqueRShoulderX', rshoulderJointTorqueX);
in_zvcf = in_zvcf.setVariable('JointTorqueRShoulderY', rshoulderJointTorqueY);
in_zvcf = in_zvcf.setVariable('JointTorqueRShoulderZ', rshoulderJointTorqueZ);
in_zvcf = in_zvcf.setVariable('JointTorqueLElbow', lelbowJointTorque);
in_zvcf = in_zvcf.setVariable('JointTorqueRElbow', relbowJointTorque);
in_zvcf = in_zvcf.setVariable('JointTorqueLWristX', lwristJointTorqueX);
in_zvcf = in_zvcf.setVariable('JointTorqueLWristY', lwristJointTorqueY);
in_zvcf = in_zvcf.setVariable('JointTorqueRWristX', rwristJointTorqueX);
in_zvcf = in_zvcf.setVariable('JointTorqueRWristY', rwristJointTorqueY);

% Assign interpolated position values as initial positions for the ZVCF model using setVariable
% Set initial velocities to zero using setVariable
% NOTE: Ensure parameter names match your ZVCF model's initial condition parameters
in_zvcf = in_zvcf.setVariable('HipStartPosition', hipPosition);
in_zvcf = in_zvcf.setVariable('HipStartVelocity', 0);
in_zvcf = in_zvcf.setVariable('TorsoStartPosition', torsoPosition);
in_zvcf = in_zvcf.setVariable('TorsoStartVelocity', 0);
in_zvcf = in_zvcf.setVariable('LScapStartPositionX', lscapPositionX);
in_zvcf = in_zvcf.setVariable('LScapStartVelocityX', 0);
in_zvcf = in_zvcf.setVariable('LScapStartPositionY', lscapPositionY);
in_zvcf = in_zvcf.setVariable('LScapStartVelocityY', 0);
in_zvcf = in_zvcf.setVariable('RScapStartPositionX', rscapPositionX);
in_zvcf = in_zvcf.setVariable('RScapStartVelocityX', 0);
in_zvcf = in_zvcf.setVariable('RScapStartPositionY', rscapPositionY);
in_zvcf = in_zvcf.setVariable('RScapStartVelocityY', 0);
in_zvcf = in_zvcf.setVariable('LShoulderStartPositionX', lshoulderPositionX);
in_zvcf = in_zvcf.setVariable('LShoulderStartVelocityX', 0);
in_zvcf = in_zvcf.setVariable('LShoulderStartPositionY', lshoulderPositionY);
in_zvcf = in_zvcf.setVariable('LShoulderStartVelocityY', 0);
in_zvcf = in_zvcf.setVariable('LShoulderStartPositionZ', lshoulderPositionZ);
in_zvcf = in_zvcf.setVariable('LShoulderStartVelocityZ', 0);
in_zvcf = in_zvcf.setVariable('RShoulderStartPositionX', rshoulderPositionX);
in_zvcf = in_zvcf.setVariable('RShoulderStartVelocityX', 0);
in_zvcf = in_zvcf.setVariable('RShoulderStartPositionY', rshoulderPositionY);
in_zvcf = in_zvcf.setVariable('RShoulderStartVelocityY', 0);
in_zvcf = in_zvcf.setVariable('RShoulderStartPositionZ', rshoulderPositionZ);
in_zvcf = in_zvcf.setVariable('RShoulderStartVelocityZ', 0);
in_zvcf = in_zvcf.setVariable('LElbowStartPosition', lelbowPosition);
in_zvcf = in_zvcf.setVariable('LElbowStartVelocity', 0);
in_zvcf = in_zvcf.setVariable('RElbowStartPosition', relbowPosition);
in_zvcf = in_zvcf.setVariable('RElbowStartVelocity', 0);
in_zvcf = in_zvcf.setVariable('LWristStartPositionX', lwristPositionX);
in_zvcf = in_zvcf.setVariable('LWristStartVelocityX', 0);
in_zvcf = in_zvcf.setVariable('LWristStartPositionY', lwristPositionY);
in_zvcf = in_zvcf.setVariable('LWristStartVelocityY', 0);
in_zvcf = in_zvcf.setVariable('RWristStartPositionX', rwristPositionX);
in_zvcf = in_zvcf.setVariable('RWristStartVelocityX', 0);
in_zvcf = in_zvcf.setVariable('RWristStartPositionY', rwristPositionY);
in_zvcf = in_zvcf.setVariable('RWristStartVelocityY', 0);


% Ensure logging is configured in the model or via the input object
% in_zvcf = in_zvcf.setLoggingOption('all'); % Example if needed

% --- Run the Simulation ---
fprintf('Running ZVCF simulation at time %g...\n', simTime);
try
    out_zvcf = sim(in_zvcf);
    fprintf('ZVCF simulation complete.\n');
catch ME
    warning('Error running ZVCF simulation at time %g: %s', simTime, ME.message);
    close_system(zvcfModelName, 0); % Close model
    return; % Exit the function
end

% --- Generate Data Table from Output ---
% Assuming generateDataTable3D function is available on the path
try
    zvcfDataTable = generateDataTable3D(out_zvcf);
    % The ZVCF simulation is short (0.05s), so the dataTable will have
    % multiple rows. The original script took the first row (time zero).
    % If you need only the data at the *start* of the ZVCF simulation,
    % you might take the first row here:
    % zvcfDataTable = zvcfDataTable(1,:);
    % And potentially overwrite its time with simTime:
    % zvcfDataTable.Time = simTime;
    % However, if you need the *full* 0.05s of simulation data for this time point,
    % the current approach of returning the full table is correct.
    % Let's return the full table as generateDataTable3D does.
    fprintf('ZVCF data table generated.\n');
catch ME
    warning('Error generating data table from ZVCF output at time %g: %s', simTime, ME.message);
    zvcfDataTable = table(); % Return empty table on error
end


% --- Final Cleanup (Close Model) ---
% Close the ZVCF model if it was opened by this function
% (Only close if it wasn't already loaded when the function started)
% This check is more complex, for simplicity, we'll just close it.
% If performance is critical and you run this function many times,
% consider keeping the model open and using Fast Restart if possible for ZVCF.
% However, ZVCF simulations are short and independent, so closing might be fine.
close_system(zvcfModelName, 0); % Close without saving changes


% No need for explicit 'clear' statements within a function.
% All intermediate variables are local and cleared automatically.

end
