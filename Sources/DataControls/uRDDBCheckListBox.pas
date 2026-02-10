unit uRDDBCheckListBox;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.ComCtrls, Vcl.DBCtrls,
  Data.DB, Winapi.Messages, Vcl.CheckLst;

type
  TRDDBCheckListBox = class(TCheckListBox)
  private
    FDataLink: TFieldDataLink;
    FDelimiter: Char;
    FValues: TStrings;
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    procedure DataChange(Sender: TObject);
    procedure SetDataField(const Value: string);
    procedure SetDataSource(const Value: TDataSource);
    procedure SetDelimiter(const Value: Char);
    procedure SetValues(const Value: TStrings);
  protected
    procedure UpdateData(Sender: TObject);
    procedure ClickCheck; override;
    procedure CMExit(var Msg: TMessage); message CM_EXIT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CheckedItems: string;
    function CheckedValues: string;
    procedure Clear; override;
    property Field: TField read GetField;
  published
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property Delimiter: Char read FDelimiter write SetDelimiter;
    property Values: TStrings read FValues write SetValues;
  end;

implementation

uses
  System.StrUtils;

function TRDDBCheckListBox.CheckedItems: string;
var
  sl: TStringList;
begin
  Result := EmptyStr;

  sl := TStringList.Create;
  try
    sl.StrictDelimiter := True;
    sl.Delimiter := FDelimiter;

    for var i := 0 to Pred(Items.Count) do
    begin
      if Checked[i] then
        sl.Add(Items[i]);
    end;

    Result := sl.DelimitedText;
  finally
    sl.Free;
  end;
end;

function TRDDBCheckListBox.CheckedValues: string;
var
  sl: TStringList;
begin
  Result := EmptyStr;

  sl := TStringList.Create;
  try
    sl.StrictDelimiter := True;
    sl.Delimiter := FDelimiter;

    for var i := 0 to Pred(Items.Count) do
    begin
      if Checked[i] then
        sl.Add(Values[i]);
    end;

    Result := sl.DelimitedText;
  finally
    sl.Free;
  end;
end;

procedure TRDDBCheckListBox.Clear;
begin
  inherited;
  Items.Clear;
  Values.Clear;
end;

procedure TRDDBCheckListBox.ClickCheck;
begin
  if FDataLink.Editing then
    FDataLink.Modified;
  inherited;
end;

procedure TRDDBCheckListBox.CMExit(var Msg: TMessage);
begin
  try
    FDataLink.UpdateRecord;
  except
    on Exception do
      SetFocus;
  end;
end;

constructor TRDDBCheckListBox.Create(AOwner: TComponent);
begin
  inherited;
  FValues := TStringList.Create;
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
  FDelimiter := ',';
end;

procedure TRDDBCheckListBox.DataChange(Sender: TObject);
var
  sl: TStringList;
begin
  if (Assigned(FDataLink.DataSource)) and (Assigned(FDataLink.Field)) then
  begin
    try
      sl := TStringList.Create;
      sl.Delimiter := Delimiter;
      sl.StrictDelimiter := True;
      sl.DelimitedText := FDataLink.Field.AsString;
      for var i := 0 to Pred(Values.Count) do
        Checked[i] := (sl.IndexOf(Values[i]) > -1);
    finally
      sl.Free;
    end;
  end;
end;

destructor TRDDBCheckListBox.Destroy;
begin
  FValues.Free;
  FDataLink.Free;
  inherited;
end;

function TRDDBCheckListBox.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

function TRDDBCheckListBox.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

function TRDDBCheckListBox.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TRDDBCheckListBox.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
  if not(csLoading in ComponentState) then
    DataChange(nil);
end;

procedure TRDDBCheckListBox.SetDataSource(const Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  if not(csLoading in ComponentState) then
    DataChange(nil);
end;

procedure TRDDBCheckListBox.SetDelimiter(const Value: Char);
begin
  FDelimiter := Value;
end;

procedure TRDDBCheckListBox.SetValues(const Value: TStrings);
begin
  FValues.Assign(Value);
end;

procedure TRDDBCheckListBox.UpdateData(Sender: TObject);
begin
  if (Assigned(FDataLink.DataSource)) and (Assigned(FDataLink.Field)) then
    FDataLink.Field.AsString := CheckedValues;
end;

end.
