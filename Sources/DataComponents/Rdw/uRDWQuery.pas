unit uRDWQuery;

interface

uses
  System.SysUtils, System.Classes, uDWAbout, uRESTDWPoolerDB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uDWConstsData, uRDConnection;

type
  TRDQueryCustom = class(TRESTDWClientSQL)
  private
    FParamCheck: Boolean;
    procedure SetParamCheck(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    procedure DoBeforeOpen; override;
  published
    property ParamCheck: Boolean read FParamCheck write SetParamCheck;
  end;

implementation

{ TRDQueryCustom }

uses uLib;

constructor TRDQueryCustom.Create(AOwner: TComponent);
begin
  inherited;
  BinaryRequest := True;
end;

procedure TRDQueryCustom.DoBeforeOpen;
begin
  inherited;
  SQL.Text := TRDLib.SQLAdapter(SQL.Text, TRDConnection(DataBase).DriverName, DataBase.PoolerService);
end;

procedure TRDQueryCustom.SetParamCheck(const Value: Boolean);
begin
  FParamCheck := Value;
end;

end.
