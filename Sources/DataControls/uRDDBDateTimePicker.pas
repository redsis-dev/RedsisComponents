unit uRDDBDateTimePicker;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.ComCtrls, Vcl.DBCtrls,
    Data.DB, Winapi.Messages;

type
  TRDDBDateTimePicker = class(TDateTimePicker)
  private
    FDataLink: TFieldDataLink;
    function GetDataField: string;
    function GetDataSource: TDataSource;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(const Value: TDataSource);
    procedure DataChange(Sender: TObject);
    function GetField: TField;
  protected
    procedure UpdateData(Sender: TObject);
    procedure Change; override;
    procedure CMExit(var Msg: TMessage); message CM_EXIT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Field: TField read GetField;
  published
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
  end;

implementation

procedure TRDDBDateTimePicker.Change;
begin
  if not FDataLink.Editing then
    FDataLink.Edit;
  FDataLink.Modified;
  inherited;
end;

procedure TRDDBDateTimePicker.CMExit(var Msg: TMessage);
begin
  try
    FDataLink.UpdateRecord;
  except
    on Exception do
      SetFocus;
  end;
end;

constructor TRDDBDateTimePicker.Create(AOwner: TComponent);
begin
  inherited;
  FDataLink := TFieldDataLink.Create;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
  Self.Date := Now;
end;

procedure TRDDBDateTimePicker.DataChange(Sender: TObject);
begin
  if Assigned(FDataLink.DataSource) and Assigned(FDataLink.Field) then
  begin
    if FDataLink.Field.AsDateTime <> StrToDate('30/12/1899') then
    begin
      Self.Date := FDataLink.Field.AsDateTime;
      Self.Time := FDataLink.Field.AsDateTime;
    end
    else
    begin
      Self.Date := Now;
      Self.Time := Now;
    end;
  end;
end;

destructor TRDDBDateTimePicker.Destroy;
begin
  FDataLink.Free;
  inherited;
end;

function TRDDBDateTimePicker.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

function TRDDBDateTimePicker.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

function TRDDBDateTimePicker.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TRDDBDateTimePicker.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

procedure TRDDBDateTimePicker.SetDataSource(const Value: TDataSource);
begin
  FDataLink.DataSource := Value;
end;

procedure TRDDBDateTimePicker.UpdateData(Sender: TObject);
begin
  FDataLink.Field.AsDateTime := Self.Date + Self.Time;
end;

end.
