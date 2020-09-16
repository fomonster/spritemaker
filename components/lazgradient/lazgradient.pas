{ Ce fichier a été automatiquement créé par Lazarus. Ne pas l'éditer !
Cette source est seulement employée pour compiler et installer le paquet.
 }

unit lazgradient; 

interface

uses
  Gradient, LazarusPackageIntf; 

implementation

procedure Register; 
begin
  RegisterUnit('Gradient', @Gradient.Register); 
end; 

initialization
  RegisterPackage('lazgradient', @Register); 
end.
