function varargout = facet_dispersion(varargin)
% FACET_DISPERSION M-file for facet_dispersion.fig
%      FACET_DISPERSION, by itself, creates a new FACET_DISPERSION or raises the existing
%      singleton*.
%
%      H = FACET_DISPERSION returns the handle to a new FACET_DISPERSION or the handle to
%      the existing singleton*.
%
%      FACET_DISPERSION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FACET_DISPERSION.M with the given input arguments.
%
%      FACET_DISPERSION('Property','Value',...) creates a new FACET_DISPERSION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before facet_dispersion_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to facet_dispersion_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help facet_dispersion

% Last Modified by GUIDE v2.5 21-Jun-2012 20:10:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @facet_dispersion_OpeningFcn, ...
                   'gui_OutputFcn',  @facet_dispersion_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before facet_dispersion is made visible.
function facet_dispersion_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to facet_dispersion (see VARARGIN)

% Choose default command line output for facet_dispersion
handles.output = hObject;

set(hObject, 'Toolbar', 'figure');

gui_statusDisp(handles, 'Loading...');
% handles.bpmd = '8';
% handles.bpms.name = model_nameRegion('BPMS', 'LI19');
handles.bpmd = '57';
handles.bpms.name = model_nameRegion('BPMS', {'LI19' 'LI20' });
handles.bpms.z    = control_deviceGet(handles.bpms.name, 'Z');

allname                     = model_nameRegion({'BEND' 'BTRM' 'BNDS' 'KICK' 'QUAD'...
                                'QTRM' 'QUAS' 'XCOR' 'YCOR' 'BPMS'}, {'LI19' 'LI20'});
allz                        = control_deviceGet(allname, 'Z');
[handles.model.z, sortord]  = sort(allz);
handles.model.name          = allname(sortord);
handles.model.z             = control_deviceGet(handles.model.name, 'Z');
handles.model.design.twiss  = model_rMatGet(handles.model.name, [], {'MODE=1' 'TYPE=DESIGN'}, 'twiss')';
handles.model.design.etax   = handles.model.design.twiss(:, 5) * 1e3;
handles.model.design.etay   = handles.model.design.twiss(:, 10) * 1e3;
% handles.model.database.twiss= model_rMatGet(handles.model.name, [], {'MODE=1' 'TYPE=DATABASE'}, 'twiss')';
% handles.model.database.etax    = handles.model.database.twiss(:, 5);
% handles.model.database.etay    = handles.model.database.twiss(:, 10);

handles.ip.z                = model_rMatGet('W203179T', [], 'TYPE=DESIGN', 'Z');

handles.bpms.index = zeros(size(handles.bpms.name));
for ix = 1:numel(handles.bpms.name)
    handles.bpms.index(ix) = strmatch(handles.bpms.name(ix), handles.model.name);
end

set(handles.popupmenu_bpmselect, 'String', [cellstr('ALL'); handles.bpms.name]);
set(handles.listbox_names, 'String', handles.bpms.name, 'Value', 1:numel(handles.bpms.name));
handles.data_ok = 0;
handles = update_gui(handles);

gui_statusDisp(handles, 'Loaded and ready to use!');
% Get default command line output from handles structure
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes facet_dispersion wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function handles = update_gui(handles)
handles.use = reshape(ismember(1:numel(handles.bpms.name), get(handles.listbox_names, 'Value')), [], 1);
handles.data.nsamp = str2int(get(handles.edit_nsamp, 'String'));
handles.data.nstep = str2int(get(handles.edit_nstep, 'String'));
handles.data.knob  = get(handles.popupmenu_knob, 'String');
handles.data.knobv = get(handles.popupmenu_knob, 'Value');
handles.tmitcut = get(handles.checkbox_tmitcut, 'Value');
handles.tmitmin = str2double(get(handles.edit_tmitmin, 'String'));
handles.dither = get(handles.checkbox_dither, 'Value');
handles.fitorder = str2int(get(handles.edit_fitorder, 'String'));
handles.fitenergy = 1e3 * str2double(get(handles.edit_fitenergy, 'String'));
handles.range = str2double(get(handles.edit_range, 'String'));
handles.plotraw = get(handles.checkbox_plotraw, 'Value');
handles.plotdisp = get(handles.checkbox_plotdisp, 'Value');
handles.plotdesign = get(handles.checkbox_plotdesign, 'Value');
handles.plot_fitorder = get(handles.popupmenu_plot_fitorder, 'Value');
handles.plotresiduals = get(handles.checkbox_plotresiduals, 'Value');
handles.plotip = get(handles.checkbox_showip, 'Value');
handles.bpmselect = get(handles.popupmenu_bpmselect, 'Value') - 1;
if handles.fitorder < handles.plot_fitorder
    set(handles.popupmenu_plot_fitorder, 'Value', handles.fitorder);
    handles.plot_fitorder = handles.fitorder;
end
set(handles.popupmenu_plot_fitorder, 'String', cellstr(num2str(reshape(1:handles.fitorder, [], 1))));


% --- Outputs from this function are returned to the command line.
function varargout = facet_dispersion_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


varargout{1} = handles.output;

guidata(hObject, handles);


% --- Executes on button press in pushbutton_acquire.
function pushbutton_acquire_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_acquire (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.issaved = 0;

% clear out data arrays
x       = zeros(handles.data.nstep, numel(handles.bpms.name), handles.data.nsamp);
y       = zeros(handles.data.nstep, numel(handles.bpms.name), handles.data.nsamp);
tmit    = zeros(handles.data.nstep, numel(handles.bpms.name), handles.data.nsamp);
pid     = zeros(handles.data.nstep, numel(handles.bpms.name), handles.data.nsamp);
stat    = zeros(handles.data.nstep, numel(handles.bpms.name), handles.data.nsamp);
phase   = zeros(handles.data.nstep, 4);
energy  = zeros(handles.data.nstep, 1);

% first figure out a scan range
gui_statusDisp(handles, 'Calculating scan range...');
fast.name = {'EP01:AMPL:171:VDES' 'EP01:AMPL:181:VDES';
             'EP01:AMPL:171:VACT' 'EP01:AMPL:181:VACT'};
klys.name = reshape(model_nameRegion('KLYS', {'LI17' 'LI18'}), 8, 2);
sbst.name = reshape(model_nameRegion('SBST', {'LI17' 'LI18'}), 1, 2);
klys.phas = reshape(control_phaseGet(klys.name), 8, 2);
sbst.phas = reshape(control_phaseGet(sbst.name), 1, 2);
fast.pdes = reshape(lcaGetSmart(fast.name(2,:)), 1, 2);
fast.phas = reshape(lcaGetSmart(fast.name(1,:)), 1, 2);
[act, d, d, d, d, enld] = control_klysStatGet(klys.name);
klys.enld = reshape(enld, 8, 2);
klys.act  = reshape(bitget(act, 1), 8, 2);
emax = zeros(size(klys.phas));
klys.pact = klys.phas + repmat(sbst.phas, 8, 1) + repmat(fast.phas, 8, 1);
klys.pmax = klys.phas + repmat(sbst.phas, 8, 1);
klys.ampl = klys.act .* klys.enld .* cosd(klys.pact);
egain = sum(sum(klys.ampl));
emax  = sum(sum(klys.enld .* klys.act .* cosd(klys.pmax)));
erange = [egain - handles.range, egain + handles.range];
prange = -acosd(erange / emax);

% check that phases are reasonable
if ~all(isreal(prange)) || any(isnan(prange)) || any(abs(prange) <= 5)
    errstring = sprintf('Range bad, fast phase shifters = [%.1f %.1f])', prange(1), prange(2));
    gui_statusDisp(handles, errstring);
    errordlg(errstring);
    return;
end

% store timestamp
handles.data.ts = now;

% store scan range
handles.data.range = linspace(-diff(prange)/2, diff(prange)/2, handles.data.nstep);
rangestr = '';
for ix = 1:handles.data.nstep
    rangestr = [rangestr sprintf('%.1f ', handles.data.range(ix))];
end
gui_statusDisp(handles, sprintf('Calculated knob steps: [%s]', rangestr));

phase_deltas = diff([0 handles.data.range 0]);

% set up AIDA for knob control
aidainit;
da = DaObject();
da.setParam('MKB', strcat('mkb:', handles.data.knob));

set(hObject, 'String', 'Acquiring...');
set(hObject, 'Enable', 'off');

% turn off energy feedbacks
fbpv = {'SIOC:SYS1:ML00:AO060'; 'SIOC:SYS1:ML00:AO084'};
fbstate = lcaGetSmart(fbpv);
lcaPutSmart(fbpv, zeros(size(fbpv)));

% iterate over steps
for ix = 1:handles.data.nstep

    % set energy here
    gui_statusDisp(handles, sprintf('Setting %s to %.1f', handles.data.knob, handles.data.range(ix)));
    da.setDaValue('MKB//VAL', DaValue(java.lang.Float(phase_deltas(ix))));

    % calculate energy from phase readback here
    phase(ix, :) = reshape(lcaGetSmart(fast.name), 1, []);  %phase(:, [1:3]) is VDES
    pact = klys.phas + repmat(sbst.phas, 8, 1) + repmat(phase(ix, [1 3]), 8, 1);
    energy(ix) = sum(sum(klys.act .* klys.enld .* cosd(pact))) - egain;

    % acquire BPM data here
    gui_statusDisp(handles, sprintf('Step %d/%d: Acquiring %d samples on BPMD %s...', ...
        ix, handles.data.nstep, handles.data.nsamp, handles.bpmd));

    [x(ix, :, :), y(ix, :, :), tmit(ix, :, :), pid(ix, :, :), stat(ix, :, :)] ...
        = control_bpmAidaGet(handles.bpms.name, handles.data.nsamp, handles.bpmd);
end

% restore energy multiknob
da.setDaValue('MKB//VAL', DaValue(java.lang.Float(phase_deltas(end))));

% turn feedbacks back on
lcaPutSmart(fbpv,fbstate);

set(hObject, 'String', 'Acquire');
set(hObject, 'Enable', 'on');
gui_statusDisp(handles, 'Acquisition finished.');

% shift BPMs to rows
handles.data.x      = permute(x, [2 3 1]);
handles.data.y      = permute(y, [2 3 1]);
handles.data.tmit   = permute(tmit, [2 3 1]);
handles.data.pid    = permute(pid, [2 3 1]);
handles.data.stat   = permute(stat, [2 3 1]);

% shift phase and energy to match BPM data
handles.data.phase  = permute(repmat(phase, [1 1 numel(handles.bpms.name)]), [3 2 1]);
handles.data.energy = permute(repmat(energy,[1 handles.data.nsamp numel(handles.bpms.name)]), [3 2 1]);

handles.data_ok = 1;

handles = fit_and_plot(handles);
guidata(hObject, handles);

function handles = fit_and_plot(handles, exfig)

if nargin < 2, export = 0; else export = 1; end
if ~handles.data_ok, return; end

plots.z      = reshape(repmat(handles.bpms.z, [1 handles.data.nstep handles.data.nsamp]), [], 1);
plots.x      = reshape(handles.data.x, [], 1);
plots.y      = reshape(handles.data.y, [], 1);
plots.tmit   = reshape(handles.data.tmit, [], 1);
plots.stat   = reshape(handles.data.stat, [], 1);
plots.use    = reshape(repmat(handles.use, handles.data.nstep, handles.data.nsamp), [], 1);
plots.energy = reshape(handles.data.energy, [], 1);

% check and flag data quality
if handles.tmitcut
    plots.stat = plots.stat & (plots.tmit > handles.tmitmin);     
end

handles.plots = plots;

% do fitting
nbpms = numel(handles.bpms.name);

fit.z = reshape(plots.z(1:nbpms), nbpms, []);
fit.x = reshape(plots.x, nbpms, []);
fit.y = reshape(plots.y, nbpms, []);
fit.tmit = reshape(plots.tmit, nbpms, []);
fit.stat = reshape(plots.stat, nbpms, []);
fit.use = any(fit.stat, 2) & handles.use;
fit.energy = reshape(plots.energy, nbpms, []);

handles.fit = fit;
parx = zeros(handles.fitorder + 1, nbpms);
pary = zeros(handles.fitorder + 1, nbpms);
parStdx = zeros(handles.fitorder + 1, nbpms);
parStdy = zeros(handles.fitorder + 1, nbpms);

eFit = linspace(min(min(fit.energy))/handles.fitenergy, max(max(fit.energy))/handles.fitenergy, 100)';
xFit = zeros(numel(eFit), nbpms);
yFit = zeros(numel(eFit), nbpms);

for ix = 1:nbpms
    [parx(:, ix), xFit(:,ix), parStdx(:, ix), d, mse, pcov, rfe] = ...
        util_polyFit(fit.energy(ix,:)'/handles.fitenergy, fit.x(ix,:)', handles.fitorder, [], eFit);
    [pary(:, ix), yFit(:,ix), parStdy(:, ix), d, mse, pcov, rfe] = ...
        util_polyFit(fit.energy(ix,:)'/handles.fitenergy, fit.y(ix,:)', handles.fitorder, [], eFit);
end

handles.fit.coef.x = fliplr(permute(parx, [2 1]));
handles.fit.coef.y = fliplr(permute(pary, [2 1]));
handles.fit.coef.xStd = fliplr(permute(parStdx, [2 1]));
handles.fit.coef.yStd = fliplr(permute(parStdy, [2 1]));
handles.fit.eFit = eFit;
handles.fit.xFit = xFit;
handles.fit.yFit = yFit;

handles.data.fit = handles.fit;

if export
    plotdims = {'x' 'y'};
    plotaxes = [subplot(2, 1, 1) subplot(2, 1, 2)];
else
    plotdims = {'x' 'y' 'tmit'};
    plotaxes = [handles.('axes_x') handles.('axes_y') handles.('axes_tmit')];
end



% do the plotting
for ix = 1:numel(plotdims)
    ax = plotaxes(ix);
    cla(ax);
    hold(ax, 'all');
    z_start = min(plots.z(plots.use));
    z_end   = max(plots.z(plots.use));
    plot(ax, [z_start z_end], [0 0], 'k-', 'LineWidth', 1);
    if handles.plotraw && handles.bpmselect ~= 0
        set(ax, 'XLim', [min(eFit) max(eFit)]);
        if ~export, set(get(handles.axes_tmit, 'XLabel'), 'String', 'dE/E'); end
    else
        set(ax, 'XLim', [z_start-1 z_end+1]);
        if ~export, set(get(handles.axes_tmit, 'XLabel'), 'String', 'Z [m]'); end
    end
    
    if handles.plotraw && handles.bpmselect ~= 0
        if ix ~= 3
            % plot raw bpm data
            alldata = handles.data.(plotdims{ix});
            data = reshape(alldata(handles.bpmselect, :, :), [], 1);
            engy = reshape(handles.data.energy(handles.bpmselect, :, :)/handles.fitenergy, [], 1);
            stats = logical(reshape(handles.data.stat(handles.bpmselect, :, :), [], 1));
            plot(ax, engy(stats), data(stats), 'k*');
            if ~all(stats), plot(ax, engy(~stats), data(~stats), 'r*'); end
            % plot fit
            data = handles.fit.(strcat(plotdims{ix}, 'Fit'));
            energydata = handles.fit.eFit;
            plot(ax, energydata, data(:, handles.bpmselect), 'k-');        
        end 
    elseif handles.plotraw && handles.bpmselect == 0
        data = plots.(plotdims{ix});
        stem(ax, plots.z(plots.stat & plots.use), data(plots.stat & plots.use), 'bo');
        if ~all(plots.stat), stem(ax, plots.z(~plots.stat), data(~plots.stat), 'ro'); end
        if ~all(plots.use), stem(ax, plots.z(~plots.use), data(~plots.use), 'ko'); end
    end
    if handles.plotdesign && ix ~= 3
        data = handles.model.design.(strcat('eta', plotdims{ix}));
        zdata = handles.model.z;
        doPlot = (zdata >= z_start) & (zdata <= z_end);
        plot(ax, zdata(doPlot), data(doPlot), 'g--', 'LineWidth', 2);
    end
    if handles.plotdisp && ix ~= 3
        data = handles.fit.coef.(plotdims{ix});
        dataStd = handles.fit.coef.(strcat(plotdims{ix}, 'Std'));
        errorbar(ax, fit.z(fit.use), data(fit.use, handles.plot_fitorder + 1), dataStd(fit.use, 1), ...
            'LineStyle', ':', 'Color', 'b', 'LineWidth', 2, 'Parent', ax);
        ylabel(ax, strcat({'D_'}, plotdims{ix}, {' [mm]'}));

    end

    if handles.plotresiduals && ix ~= 3
        design = handles.model.design.(strcat('eta', plotdims{ix}));
        data = handles.fit.coef.(plotdims{ix});
        if handles.plot_fitorder ~= 1
            design = 0 * design;
        end
        design_bpms = design(handles.bpms.index);
        dataStd = handles.fit.coef.(strcat(plotdims{ix}, 'Std'));
        errorbar(ax, fit.z(fit.use), data(fit.use, handles.plot_fitorder + 1) - design_bpms(fit.use), dataStd(fit.use, 1), ...
            'LineStyle', ':', 'Color', 'r', 'LineWidth', 2, 'Parent', ax);
    end
    
    if handles.plotip
        ylims = ylim(ax);
        ys = linspace(min(ylims), max(ylims), 10);
        plot(ax, repmat(handles.ip.z, size(ys)), ys, 'm--');
    end
        
end

if export
    subplot(2, 1, 1);
    title(strcat({'FACET Dispersion '}, datestr(handles.data.ts)));
    subplot(2, 1, 2);
    xlabel('Z [m]');
    util_appFonts(exfig, 'fontName', 'times', 'fontSize', 14);
    
end
drawnow;

function edit_nsamp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nsamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = update_gui(handles);
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit_nsamp as text
%        str2double(get(hObject,'String')) returns contents of edit_nsamp as a double


% --- Executes during object creation, after setting all properties.
function edit_nsamp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nsamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_table_Callback(hObject, eventdata, handles)
% hObject    handle to edit_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_table as text
%        str2double(get(hObject,'String')) returns contents of edit_table as a double


% --- Executes during object creation, after setting all properties.
function edit_table_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_names.
function listbox_names_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_names (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = update_gui(handles);
handles = fit_and_plot(handles);
guidata(hObject, handles);
% Hints: contents = get(hObject,'String') returns listbox_names contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_names


% --- Executes during object creation, after setting all properties.
function listbox_names_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_names (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_knob_Callback(hObject, eventdata, handles)
% hObject    handle to edit_knob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = update_gui(handles);
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit_knob as text
%        str2double(get(hObject,'String')) returns contents of edit_knob as a double


% --- Executes during object creation, after setting all properties.
function edit_knob_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_knob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_nstep_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = update_gui(handles);
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit_nstep as text
%        str2double(get(hObject,'String')) returns contents of edit_nstep as a double


% --- Executes during object creation, after setting all properties.
function edit_nstep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_tmitcut.
function checkbox_tmitcut_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_tmitcut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = update_gui(handles);
handles = fit_and_plot(handles);
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox_tmitcut



function edit_tmitmin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tmitmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = update_gui(handles);
handles = fit_and_plot(handles);
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit_tmitmin as text
%        str2double(get(hObject,'String')) returns contents of edit_tmitmin as a double


% --- Executes during object creation, after setting all properties.
function edit_tmitmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tmitmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_dither.
function checkbox_dither_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_dither (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = update_gui(handles);
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox_dither



function edit_fitorder_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fitorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = update_gui(handles);
handles = fit_and_plot(handles);
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit_fitorder as text
%        str2double(get(hObject,'String')) returns contents of edit_fitorder as a double


% --- Executes during object creation, after setting all properties.
function edit_fitorder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fitorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_knob.
function popupmenu_knob_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_knob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = update_gui(handles);
guidata(hObject, handles);
% Hints: contents = get(hObject,'String') returns popupmenu_knob contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_knob


% --- Executes during object creation, after setting all properties.
function popupmenu_knob_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_knob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_range_Callback(hObject, eventdata, handles)
% hObject    handle to edit_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = update_gui(handles);
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit_range as text
%        str2double(get(hObject,'String')) returns contents of edit_range as a double


% --- Executes during object creation, after setting all properties.
function edit_range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_save.
function handles = pushbutton_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = util_dataSave(handles.data, 'facet_dispersion', handles.data.knob, handles.data.ts);
gui_statusDisp(handles, sprintf('Data saved to %s/%s', pathname, filename));
handles.issaved = 1;
guidata(hObject, handles);

% --- Executes on button press in pushbutton_load.
function pushbutton_load_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.data = util_dataLoad();
handles.data_ok = 1;
handles.issaved = 1;
if ~isfield(handles.data, 'ts'), handles.data.ts = now; end
set(handles.edit_nstep, 'String', num2str(handles.data.nstep));
set(handles.edit_nsamp, 'String', num2str(handles.data.nsamp));
set(handles.popupmenu_knob, 'Value', handles.data.knobv);
handles = update_gui(handles);
handles = fit_and_plot(handles);
gui_statusDisp(handles, 'Data loaded.');
guidata(hObject, handles);


% --- Executes on button press in pushbutton_configSave.
function pushbutton_configSave_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_configSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox_plotdisp.
function checkbox_plotdisp_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_plotdisp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = update_gui(handles);
handles = fit_and_plot(handles);
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox_plotdisp


% --- Executes on button press in checkbox_plotraw.
function checkbox_plotraw_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_plotraw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = update_gui(handles);
handles = fit_and_plot(handles);
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox_plotraw



function edit_fitenergy_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fitenergy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = update_gui(handles);
handles = fit_and_plot(handles);
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit_fitenergy as text
%        str2double(get(hObject,'String')) returns contents of edit_fitenergy as a double


% --- Executes during object creation, after setting all properties.
function edit_fitenergy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fitenergy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_plot_fitorder.
function popupmenu_plot_fitorder_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_plot_fitorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = update_gui(handles);
handles = fit_and_plot(handles);
guidata(hObject, handles);

% Hints: contents = get(hObject,'String') returns popupmenu_plot_fitorder contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_plot_fitorder


% --- Executes during object creation, after setting all properties.
function popupmenu_plot_fitorder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_plot_fitorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_plotdesign.
function checkbox_plotdesign_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_plotdesign (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = update_gui(handles);
handles = fit_and_plot(handles);
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox_plotdesign


% --- Executes on button press in pushbutton_print.
function pushbutton_print_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_print (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.issaved
    handles = pushbutton_save_Callback(hObject, [], handles);
end

exfig = figure;
handles = fit_and_plot(handles, exfig);
util_printLog(exfig);
guidata(hObject, handles);


% --- Executes on button press in checkbox_plotresiduals.
function checkbox_plotresiduals_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_plotresiduals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = update_gui(handles);
handles = fit_and_plot(handles);
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox_plotresiduals


% --- Executes on selection change in popupmenu_bpmselect.
function popupmenu_bpmselect_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_bpmselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = update_gui(handles);
handles = fit_and_plot(handles);
guidata(hObject, handles);
% Hints: contents = get(hObject,'String') returns popupmenu_bpmselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_bpmselect


% --- Executes during object creation, after setting all properties.
function popupmenu_bpmselect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_bpmselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_zoom.
function checkbox_zoom_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject, 'Value')
    zoom on;
else
    zoom off;
end
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox_zoom


function checkbox_showip_Callback(hObject, eventdata, handles)
handles = update_gui(handles);
handles = fit_and_plot(handles);
guidata(hObject, handles);
