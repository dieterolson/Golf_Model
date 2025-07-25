function GolfSwingDataGeneratorGUI()
    % Golf Swing Data Generator GUI - Enhanced GUI for generating golf swing training data
    % NO Java components - uses only native MATLAB GUI elements
    
    fprintf('Launching Golf Swing Training Data Generator GUI...\n');
    
    % Create main figure - basic settings only
    fig = figure('Name', 'Golf Swing Data Generator - Enhanced', ...
                 'Position', [100, 100, 1000, 700], ...
                 'Color', [0.95, 0.95, 0.95], ...
                 'MenuBar', 'none', ...
                 'ToolBar', 'none');
    
    % Initialize handles
    handles = struct();
    handles.should_stop = false;
    handles.trial_results = {};
    
    % === TITLE ===
    uicontrol('Parent', fig, ...
              'Style', 'text', ...
              'String', 'Golf Swing Data Generator - Enhanced', ...
              'Position', [50, 650, 900, 30], ...
              'FontSize', 16, ...
              'FontWeight', 'bold', ...
              'BackgroundColor', [0.2, 0.4, 0.8], ...
              'ForegroundColor', 'white');
    
    % === LEFT PANEL: SETTINGS ===
    settings_panel = uipanel('Parent', fig, ...
                            'Title', 'Settings', ...
                            'Position', [20, 350, 460, 290], ...
                            'BackgroundColor', [0.97, 0.97, 0.97]);
    
    % Number of trials
    uicontrol('Parent', settings_panel, ...
              'Style', 'text', ...
              'String', 'Number of Trials:', ...
              'Position', [10, 240, 120, 20], ...
              'HorizontalAlignment', 'left');
    
    handles.num_trials = uicontrol('Parent', settings_panel, ...
                                   'Style', 'edit', ...
                                   'String', '5', ...
                                   'Position', [140, 240, 60, 20]);
    
    % Simulation time
    uicontrol('Parent', settings_panel, ...
              'Style', 'text', ...
              'String', 'Simulation Time (s):', ...
              'Position', [10, 210, 120, 20], ...
              'HorizontalAlignment', 'left');
    
    handles.sim_time = uicontrol('Parent', settings_panel, ...
                                 'Style', 'edit', ...
                                 'String', '2.0', ...
                                 'Position', [140, 210, 60, 20]);
    
    % Output folder
    uicontrol('Parent', settings_panel, ...
              'Style', 'text', ...
              'String', 'Output Folder:', ...
              'Position', [10, 180, 120, 20], ...
              'HorizontalAlignment', 'left');
    
    handles.output_folder = uicontrol('Parent', settings_panel, ...
                                      'Style', 'edit', ...
                                      'String', 'output_data', ...
                                      'Position', [140, 180, 200, 20]);
    
    % Data source checkboxes
    uicontrol('Parent', settings_panel, ...
              'Style', 'text', ...
              'String', 'Data Sources:', ...
              'Position', [10, 140, 120, 20], ...
              'HorizontalAlignment', 'left', ...
              'FontWeight', 'bold');
    
    handles.use_signal_bus = uicontrol('Parent', settings_panel, ...
                                       'Style', 'checkbox', ...
                                       'String', 'Signal Bus Data', ...
                                       'Position', [20, 110, 150, 20], ...
                                       'Value', 1);
    
    handles.use_simscape = uicontrol('Parent', settings_panel, ...
                                     'Style', 'checkbox', ...
                                     'String', 'Simscape Data', ...
                                     'Position', [20, 85, 150, 20], ...
                                     'Value', 1);
    
    handles.use_workspace = uicontrol('Parent', settings_panel, ...
                                      'Style', 'checkbox', ...
                                      'String', 'Workspace Variables', ...
                                      'Position', [20, 60, 150, 20], ...
                                      'Value', 0);
    
    % Status text area
    handles.status_text = uicontrol('Parent', settings_panel, ...
                                   'Style', 'text', ...
                                   'String', 'Ready to generate simulation data', ...
                                   'Position', [10, 10, 430, 40], ...
                                   'HorizontalAlignment', 'left', ...
                                   'BackgroundColor', [1, 1, 1], ...
                                   'FontSize', 10);
    
    % === RIGHT PANEL: CONTROLS AND RESULTS ===
    results_panel = uipanel('Parent', fig, ...
                           'Title', 'Generation Controls & Results', ...
                           'Position', [500, 350, 480, 290], ...
                           'BackgroundColor', [0.97, 0.97, 0.97]);
    
    % Control buttons
    handles.generate_btn = uicontrol('Parent', results_panel, ...
                                     'Style', 'pushbutton', ...
                                     'String', 'Generate Dataset', ...
                                     'Position', [20, 230, 150, 35], ...
                                     'FontSize', 12, ...
                                     'FontWeight', 'bold', ...
                                     'BackgroundColor', [0.2, 0.7, 0.2], ...
                                     'ForegroundColor', 'white', ...
                                     'Callback', @(~,~) generateData(handles));
    
    handles.stop_btn = uicontrol('Parent', results_panel, ...
                                 'Style', 'pushbutton', ...
                                 'String', 'Stop', ...
                                 'Position', [190, 230, 100, 35], ...
                                 'FontSize', 12, ...
                                 'FontWeight', 'bold', ...
                                 'BackgroundColor', [0.8, 0.2, 0.2], ...
                                 'ForegroundColor', 'white', ...
                                 'Enable', 'off', ...
                                 'Callback', @(~,~) stopGeneration(handles));
    
    handles.clear_btn = uicontrol('Parent', results_panel, ...
                                  'Style', 'pushbutton', ...
                                  'String', 'Clear', ...
                                  'Position', [310, 230, 80, 35], ...
                                  'FontSize', 10, ...
                                  'Callback', @(~,~) clearResults(handles));
    
    % Progress display
    handles.progress_text = uicontrol('Parent', results_panel, ...
                                      'Style', 'text', ...
                                      'String', 'Progress: Ready', ...
                                      'Position', [20, 200, 400, 20], ...
                                      'HorizontalAlignment', 'left', ...
                                      'FontWeight', 'bold');
    
    % Results display (listbox - NO Java components!)
    uicontrol('Parent', results_panel, ...
              'Style', 'text', ...
              'String', 'Trial Results:', ...
              'Position', [20, 170, 100, 20], ...
              'HorizontalAlignment', 'left', ...
              'FontWeight', 'bold');
    
    handles.results_list = uicontrol('Parent', results_panel, ...
                                     'Style', 'listbox', ...
                                     'String', {'No trials generated yet'}, ...
                                     'Position', [20, 20, 440, 140], ...
                                     'FontSize', 10, ...
                                     'BackgroundColor', [1, 1, 1]);
    
    % === BOTTOM PANEL: LOG ===
    log_panel = uipanel('Parent', fig, ...
                       'Title', 'System Log', ...
                       'Position', [20, 20, 960, 320], ...
                       'BackgroundColor', [0.97, 0.97, 0.97]);
    
    handles.log_text = uicontrol('Parent', log_panel, ...
                                 'Style', 'text', ...
                                 'String', sprintf(['Golf Swing Data Generator Initialized Successfully!\n\n' ...
                                                   'This version uses reliable MATLAB components:\n' ...
                                                   '- Native uicontrol elements\n' ...
                                                   '- Listbox for data display\n' ...
                                                   '- NO Java dependencies\n\n' ...
                                                   'Ready to generate golf swing simulation datasets for machine learning...']), ...
                                 'Position', [10, 10, 940, 280], ...
                                 'HorizontalAlignment', 'left', ...
                                 'BackgroundColor', [1, 1, 1], ...
                                 'FontSize', 10);
    
    % Store handles
    guidata(fig, handles);
    
    fprintf('GUI launched successfully!\n');
end 