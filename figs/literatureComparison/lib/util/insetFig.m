function new_fig = inset_fig(main_fig, inset_fig, inset_location, inset_scale)

% given 2 figures, this function insets the 2nd figure into the 1st figure.
% inset_location indicates where in the inset should be placed. this function
% will work for main figures that already have insets


if ~exist('inset_scale', 'var')
    inset_scale = 0.35;
end

new_fig = figure;

% grab the items in the main figure
axes_in_fig = findobj(main_fig, 'type', 'axes');   
colorbars_in_fig = findobj(main_fig, 'type', 'colorbar');

% find the properties of the main axes
main_ax = axes_in_fig(end);
set(main_ax, 'units', 'centimeters');
main_ax_pos = get(main_ax, 'position');
main_ax_colormap = colormap(main_ax);

% grab the main colorbar
main_colorbar = colorbars_in_fig(end);

% copy the main axes and colorbar (if it exists), then set the same colormap
h_main_group = copyobj([main_ax, main_colorbar], new_fig);
h_main = findobj(h_main_group, 'type', 'axes');
colormap(h_main, main_ax_colormap);
set(h_main, 'units', 'centimeters');
% set(h_main, 'position', main_ax_pos);

% if the figure already contains insets, copy those as well to the new figure
for i = length(axes_in_fig)-1:-1:1
    % get the properties of the inset axes
    tmp_ax = axes_in_fig(i);
    tmp_ax_pos = get(tmp_ax, 'position');
    tmp_ax_colormap = colormap(tmp_ax);

    % copy the inset and set the colormap and position
    h_tmp = copyobj(tmp_ax, new_fig);
    colormap(h_tmp, tmp_ax_colormap);
    set(h_tmp, 'position', tmp_ax_pos)
end

% create the new inset
inset_ax = findobj(inset_fig, 'type', 'axes');
inset_ax_colormap = colormap(inset_ax);

h_inset = copyobj(inset_ax, new_fig);
colormap(h_inset, inset_ax_colormap);
set(h_inset, 'xcolor', 'w');
set(h_inset, 'ycolor', 'w');
xlabel(h_inset, '');
ylabel(h_inset, '');
set(h_inset, 'xticklabel', []);
set(h_inset, 'yticklabel', []);
set(h_inset, 'xtick', []);
set(h_inset, 'ytick', []);

% set the inset position
inset_size = min(main_ax_pos(3:4) * inset_scale);
switch inset_location
    case 'southwest'
        % setting xlim doesn't change the axes position property. 
        % width is usually longer than height. therefore need this hack
        inset_left_pos = main_ax_pos(1)+(main_ax_pos(3)-main_ax_pos(4))/2+0.02*main_ax_pos(3);
        inset_bottom_pos = main_ax_pos(2)+0.02*main_ax_pos(3);
    case 'southeast'
        inset_left_pos = main_ax_pos(1)+main_ax_pos(3)-(main_ax_pos(3)-main_ax_pos(4))/2-0.02*main_ax_pos(3)-inset_size;
        inset_bottom_pos = main_ax_pos(2)+0.02*main_ax_pos(3);
end
inset_size = min(main_ax_pos(3:4) * inset_scale);
inset_ax_pos = [inset_left_pos, inset_bottom_pos, inset_size, inset_size];
set(h_inset, 'units', 'centimeters');
set(h_inset, 'position', inset_ax_pos);
