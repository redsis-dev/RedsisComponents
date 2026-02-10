unit uFDCTable;

interface

uses
  System.Classes, Data.DB, System.SysUtils, uRDConnection, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TRDTableCustom = class(TFDTable)
  private
    FBufferChunks: Integer;
    FCachedUpdates: Boolean;
    FUniDirectional: Boolean;
    FDatabase: TRDConnection;
    procedure SetBufferChunks(const Value: Integer);
    procedure SetCachedUpdates(const Value: Boolean);
    procedure SetDatabase(const Value: TRDConnection);
    procedure SetUniDirectional(const Value: Boolean);
  public
    procedure DoBeforeOpen; override;
    procedure SetFilterText(const Value: string); override;
  published
    property BufferChunks: Integer read FBufferChunks write SetBufferChunks;
    property CachedUpdates: Boolean read FCachedUpdates write SetCachedUpdates;
    property Database: TRDConnection read FDatabase write SetDatabase;
    property UniDirectional: Boolean read FUniDirectional write SetUniDirectional;
  end;

implementation

{ TRDTableCustom }

procedure TRDTableCustom.DoBeforeOpen;
begin
  if not Assigned(Connection) then
    Connection := TFDConnection(Database);
  inherited;
end;

procedure TRDTableCustom.SetBufferChunks(const Value: Integer);
begin
  FBufferChunks := Value;
end;

procedure TRDTableCustom.SetCachedUpdates(const Value: Boolean);
begin
  FCachedUpdates := Value;
end;

procedure TRDTableCustom.SetDatabase(const Value: TRDConnection);
begin
  FDatabase := Value;
  Connection := TFDConnection(FDatabase);
end;

procedure TRDTableCustom.SetFilterText(const Value: string);
begin
  inherited SetFilterText(StringReplace(Value,'"', #39, [rfReplaceAll]));
end;

procedure TRDTableCustom.SetUniDirectional(const Value: Boolean);
begin
  FUniDirectional := Value;
end;

end.
