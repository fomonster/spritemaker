{ This file was automatically created by Lazarus. Do not edit!
This source is only used to compile and install the package.
 }

unit openglbox; 

interface

uses
  openglboxcomponent, LazarusPackageIntf; 

implementation

procedure Register; 
begin
  RegisterUnit('openglboxcomponent', @openglboxcomponent.Register); 
end; 

initialization
  RegisterPackage('openglbox', @Register); 
end.
