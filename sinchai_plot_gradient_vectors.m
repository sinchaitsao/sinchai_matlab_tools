function sinchai_plot_gradient_vectors(gradient_mat_file)
% Sinchai Tsao
% June 22nd 2011
%
% Function for plotting gradient vectors for NeuroTract
%
% sinchai_plot_gradient_vectors(gradient_mat_file)
%
% supply gradient mat file location as string argument

load(gradient_mat_file);

for i=1:length(x)
    quiver3(1,1,1,x(i),y(i),z(i));
    hold on;
end

for i=1:length(x)
    quiver3(1,1,1,-x(i),-y(i),-z(i));
    hold on;
end