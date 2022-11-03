% c3d Data files Toolbox.
%   Revision 2.0 $Date: Jan/13/2009 $ $Author: Fabrizio Patanè 
%
% C3D import.
%   High level functions:
%       c3d2c3d       - import a CAMARC file in a c3d MATLAB object
%       c3dget        - take points and analog data from a c3d MATLAB object.
%       c3devents     - convert the event field in a more usable event struct  
%   Low level import functions:
%       c3dheader     - read a c3d header
%       c3dparameters - read a c3d parameter field
%       c3ddata       - same as c3d2c3d, but with a gui if no filename is given.
%       c3dprocessor  - read the processor type from a c3d CAMARC file.
%       VaxToDouble   - convert a int32 array (max 3d) to double using vax format.
%
%   c3d data manipulation.
%        c3dlabels     - take labels from a c3d MATLAB object. 
%        c3disanalog   - check if a cell array corresponds to analog labels
%        c3dispoint    - check if a cell array corresponds to point labels
%        c3dplateframe - get the force plates transformation matrices
%        islabel       - check which items of cell array contains items are 
%                        present in another cell array
%        labelpos      - finds the indexes of selected labels in a c3d obj

