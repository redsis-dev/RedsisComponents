unit uRDDBRadioButton;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.DBCtrls,
  Data.DB, Winapi.Messages;

type
  TRDDBRadioButton = class(TRadioButton)
  private
    FDataLink: TFieldDataLink;
    FValue: string;
    function GetDataField: string;
    function GetDataSource: TDataSource;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(const Value: TDataSource);
    procedure DataChange(Sender: TObject);
    function GetField: TField;
    procedure SetValue(const Value: string);
  protected
    procedure UpdateData(Sender: TObject);
    procedure Click; override;
    procedure CMExit(var Msg: TMessage); message CM_EXIT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Field: TField read GetField;
  published
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property Value: string read FValue write SetValue;
  end;

implementation

procedure TRDDBRadioButton.Click;
begin
  inherited Click;
  if Assigned(FDataLink) and Assigned(FDataLink.Field) then
  begin
    if FDataLink.Editing then
    begin
      FDataLink.Modified;
      FDataLink.UpdateRecord;
    end;
  end;
end;

procedure TRDDBRadioButton.CMExit(var Msg: TMessage);
begin
  try
    FDataLink.UpdateRecord;
  except
    on Exception do
      SetFocus;
  end;
end;

constructor TRDDBRadioButton.Create(AOwner: TComponent);
begin
  inherited;
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
end;

procedure TRDDBRadioButton.DataChange(Sender: TObject);
begin
  if Assigned(FDataLink.DataSource) and Assigned(FDataLink.Field) then
    Checked := FDataLink.Field.AsString = FValue;
end;

destructor TRDDBRadioButton.Destroy;
begin
  FDataLink.Free;
  inherited;
end;

function TRDDBRadioButton.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

function TRDDBRadioButton.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

function TRDDBRadioButton.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TRDDBRadioButton.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

procedure TRDDBRadioButton.SetDataSource(const Value: TDataSource);
begin
  FDataLink.DataSource := Value;
end;

procedure TRDDBRadioButton.SetValue(const Value: string);
begin
  if FValue <> Value then
  begin
    FValue := Value;
    DataChange(Self);
  end;
end;

procedure TRDDBRadioButton.UpdateData(Sender: TObject);
begin
  if Checked and Assigned(FDataLink.Field) then
    FDataLink.Field.AsString := FValue;
end;

end.
