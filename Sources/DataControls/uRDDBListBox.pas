unit uRDDBListBox;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.DBCtrls,
  Data.DB, Winapi.Messages, Vcl.CheckLst;

type
  TAddValueEvent = procedure(ASender: TObject; var AValue: string; var AAccept: Boolean) of object;
  TDeleteValueEvent = procedure(ASender: TObject; var AAccept: Boolean) of object;

  TRDDBListBox = class(TListBox)
  private
    FDataLink: TFieldDataLink;
    FDelimiter: Char;
    FOnAddValue: TAddValueEvent;
    FOnDeleteValue: TDeleteValueEvent;
    FConfirmDelete: Boolean;
    FUniqueItems: Boolean;
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(const Value: TDataSource);
    procedure SetDelimiter(const Value: Char);
  protected
    procedure DataChange(Sender: TObject);
    procedure Loaded; override;
    procedure UpdateData(Sender: TObject);
    procedure CMExit(var Msg: TMessage); message CM_EXIT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear; override;
    function AddValue(const AValue: string; ASelectAfterAdd: Boolean = True): Boolean;
    function DeleteSelected: Boolean;
    function MoveNext: Boolean;
    function MovePrior: Boolean;
  public
    property Field: TField read GetField;
  published
    property ConfirmDelete: Boolean read FConfirmDelete write FConfirmDelete default True;
    property UniqueItems: Boolean read FUniqueItems write FUniqueItems default True;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property Delimiter: Char read FDelimiter write SetDelimiter;
  published
    property OnAddValue: TAddValueEvent read FOnAddValue write FOnAddValue;
    property OnDeleteValue: TDeleteValueEvent read FOnDeleteValue write FOnDeleteValue;
  end;

implementation

uses
  System.StrUtils, Vcl.Dialogs;

function TRDDBListBox.AddValue(const AValue: string; ASelectAfterAdd: Boolean): Boolean;
var
  sNew: string;
  bAccept: Boolean;
  iIndex: Integer;
begin
  Result := False;

  if not Assigned(FDataLink.Field) then
    Exit;

  sNew := Trim(AValue);
  if sNew = EmptyStr then
    Exit;

  bAccept := True;
  if Assigned(FOnAddValue) then
    FOnAddValue(Self, sNew, bAccept);

  if not bAccept then
    Exit;

  if UniqueItems then
  begin
    for var i := 0 to Pred(Items.Count) do
      if SameText(Items[i], AValue) then
      raise Exception.Create('Valor já existente.');
  end;

  iIndex := Items.Add(sNew);

  UpdateData(nil);

  if ASelectAfterAdd then
    ItemIndex := iIndex;

  Result := True;
end;

procedure TRDDBListBox.Clear;
begin
  inherited;
  Items.Clear;
end;

procedure TRDDBListBox.CMExit(var Msg: TMessage);
begin
  try
    FDataLink.UpdateRecord;
  except
    on Exception do
      SetFocus;
  end;
end;

constructor TRDDBListBox.Create(AOwner: TComponent);
begin
  inherited;
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnUpdateData := UpdateData;
  FDataLink.OnDataChange := DataChange;
  FConfirmDelete := True;
  FUniqueItems := True;
  FDelimiter := ',';
  Items.Delimiter := FDelimiter;
  Items.StrictDelimiter := True;
end;

procedure TRDDBListBox.DataChange(Sender: TObject);
begin
  if (Assigned(FDataLink.DataSource)) and (Assigned(FDataLink.Field)) then
  begin
    if csLoading in ComponentState then
      Exit;

    Items.BeginUpdate;
    try
      Items.Clear;
      if Assigned(FDataLink.Field) then
      begin
        Items.Delimiter := FDelimiter;
        Items.StrictDelimiter := True;
        Items.DelimitedText := FDataLink.Field.AsString;
      end;
    finally
      Items.EndUpdate;
    end;
  end;
end;

function TRDDBListBox.DeleteSelected: Boolean;
var
  bAccept: Boolean;
begin
  Result := False;

  if ItemIndex < varEmpty then
    Exit;

  if ConfirmDelete then
  begin
    if MessageDlg(
      Format('Deseja realmente excluir "%s"?', [Items[ItemIndex]]),
      mtConfirmation,
      [mbYes, mbNo],
      0
      ) <> mrYes then
      Exit;
  end;

  bAccept := True;
  if Assigned(FOnDeleteValue) then
    FOnDeleteValue(Self, bAccept);

  if not bAccept then
    Exit;

  Items.Delete(ItemIndex);
  UpdateData(nil);
  ItemIndex := Pred(Items.Count);

  Result := True;
end;

destructor TRDDBListBox.Destroy;
begin
  FDataLink.Free;
  inherited;
end;

function TRDDBListBox.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

function TRDDBListBox.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

function TRDDBListBox.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TRDDBListBox.Loaded;
begin
  inherited;
  DataChange(nil);
end;

function TRDDBListBox.MoveNext: Boolean;
var
  iNew: Integer;
begin
  Result := False;
  if Items.Count = varEmpty then
    Exit;
  if ItemIndex = Pred(Items.Count) then
    Exit;
  iNew := ItemIndex + 1;
  Items.Move(ItemIndex, iNew);
  Selected[iNew];
  UpdateData(nil);
  Result := True;
end;

function TRDDBListBox.MovePrior: Boolean;
var
  iNew: Integer;
begin
  Result := False;
  if Items.Count = varEmpty then
    Exit;
  if ItemIndex = varEmpty then
    Exit;
  iNew := ItemIndex - 1;
  Items.Move(ItemIndex, iNew);
  Selected[iNew];
  UpdateData(nil);
  Result := True;
end;

procedure TRDDBListBox.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
  if not(csLoading in ComponentState) then
    DataChange(nil);
end;

procedure TRDDBListBox.SetDataSource(const Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  if not(csLoading in ComponentState) then
    DataChange(nil);
end;

procedure TRDDBListBox.SetDelimiter(const Value: Char);
begin
  FDelimiter := Value;
  Items.Delimiter := FDelimiter;
end;

procedure TRDDBListBox.UpdateData(Sender: TObject);
begin
  if (Assigned(FDataLink.DataSource)) and (Assigned(FDataLink.Field)) then
    FDataLink.Field.AsString := Items.DelimitedText;
end;

end.
