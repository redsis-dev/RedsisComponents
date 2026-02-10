unit uRDModuloDataModule;

interface

uses
  System.SysUtils, System.Classes;

type
  TRDModuloDataModule = class(TDataModule)
  public
    procedure AtivarModulo; virtual;
  end;

var
  RDModuloDataModule: TRDModuloDataModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{ TRDDMModulo }

procedure TRDModuloDataModule.AtivarModulo;
begin
//
end;

end.
