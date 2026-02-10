unit uRDDBComboBox;

interface

uses
  System.Classes, Vcl.DBCtrls, Vcl.StdCtrls, Winapi.Windows, Winapi.Messages,
  Data.DB, Vcl.Controls;

type
  TRDDBComboBox = class(TCustomComboBox)
  private
    FDataLink: TFieldDataLink;
    FPaintControl: TPaintControl;
    FEnableValues: Boolean;
    FValues: TStrings;
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    function GetComboText: string;
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    function GetReadOnly: Boolean;
    procedure SetComboText(const Value: string);
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetEditReadOnly;
    procedure SetEnableValues(const Value: Boolean);
    procedure SetReadOnly(Value: Boolean);
    procedure SetValues(const Value: TStrings);
    procedure UpdateData(Sender: TObject);
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
    procedure ValuesChanged(Sender: TObject);
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  protected
    function GetPaintText: string;
    procedure Change; override;
    procedure Click; override;
    procedure ComboWndProc(var Message: TMessage; ComboWnd: HWnd; ComboProc: Pointer); override;
    procedure CreateWnd; override;
    procedure DropDown; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetItems(const Value: TStrings); override;
    procedure SetStyle(Value: TComboboxStyle); override;
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;
    procedure Clear; override;
    property Field: TField read GetField;
    property Text;
  published
    property Style; { Must be published before Items }
    property Align;
    property Anchors;
    property AutoComplete;
    property AutoDropDown;
    property BevelEdges;
    property BevelInner;
    property BevelOuter;
    property BevelKind;
    property BevelWidth;
    property BiDiMode;
    property CharCase;
    property Color;
    property Constraints;
    property Ctl3D;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property Enabled;
    property EnableValues: Boolean read FEnableValues write SetEnableValues default True;
    property Font;
    property ImeMode;
    property ImeName;
    property ItemHeight;
    property Items write SetItems;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    [Default (False)]
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property ShowHint;
    property Sorted;
    property TabOrder;
    property TabStop;
    property Touch;
    property Values: TStrings read FValues write SetValues;
    property Visible;
    property StyleElements;
    property StyleName;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGesture;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnStartDock;
    property OnStartDrag;
  end;

implementation

uses
  System.SysUtils, Vcl.Themes, Vcl.Graphics, System.UITypes, Vcl.VDBConsts;

{ TRDDBComboBox }

constructor TRDDBComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FValues := TStringList.Create;
  TStringList(FValues).OnChange := ValuesChanged;
  FEnableValues := True;
  ControlStyle := ControlStyle + [csReplicatable];
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
  FDataLink.OnEditingChange := EditingChange;
  FPaintControl := TPaintControl.Create(Self, 'COMBOBOX');
  Style := csDropDownList;
end;

destructor TRDDBComboBox.Destroy;
begin
  TStringList(FValues).OnChange := nil;
  FValues.Free;
  FreeAndNil(FPaintControl);
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TRDDBComboBox.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) then
    DataChange(Self);
end;

procedure TRDDBComboBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then
    DataSource := nil;
end;

procedure TRDDBComboBox.CreateWnd;
begin
  inherited CreateWnd;
  SetEditReadOnly;
end;

procedure TRDDBComboBox.DataChange(Sender: TObject);
begin
  if not(Style = csSimple) and DroppedDown then
    Exit;
  if FDataLink.Field <> nil then
    SetComboText(FDataLink.Field.Text)
  else
    if csDesigning in ComponentState then
    SetComboText(Name)
  else
    SetComboText('');
end;

procedure TRDDBComboBox.UpdateData(Sender: TObject);
begin
  FDataLink.Field.Text := GetComboText;
end;

procedure TRDDBComboBox.SetComboText(const Value: string);
var
  i: Integer;
  Redraw: Boolean;
begin
  if Value <> GetComboText then
  begin
    if Style <> csDropDown then
    begin
      Redraw := (Style <> csSimple) and HandleAllocated;
      if Redraw then
        SendMessage(Handle, WM_SETREDRAW, 0, 0);
      try
        if Value = '' then
          i := -1
        else
          if FEnableValues then
          i := Values.IndexOf(Value)
        else
          i := Items.IndexOf(Value);
        if i >= Items.Count then
          i := -1;
        ItemIndex := i;
      finally
        if Redraw then
        begin
          SendMessage(Handle, WM_SETREDRAW, 1, 0);
          Invalidate;
        end;
      end;
      if i >= 0 then
        Exit;
    end;
    if Style in [csDropDown, csSimple] then
      Text := Value;
  end;
end;

function TRDDBComboBox.GetComboText: string;
var
  i: Integer;
begin
  if (Style in [csDropDown, csSimple]) and (not FEnableValues) then
    Result := Text
  else
  begin
    i := ItemIndex;
    if (i < 0) or (FEnableValues and (FValues.Count < i + 1)) then
      Result := ''
    else
      if FEnableValues then
      Result := FValues[i]
    else
      Result := Items[i];
  end;
end;

procedure TRDDBComboBox.Change;
begin
  FDataLink.Edit;
  inherited Change;
  FDataLink.Modified;
end;

procedure TRDDBComboBox.Clear;
begin
  inherited;
  Items.Clear;
  Values.Clear;
end;

procedure TRDDBComboBox.Click;
begin
  FDataLink.Edit;
  inherited Click;
  FDataLink.Modified;
end;

procedure TRDDBComboBox.DropDown;
begin
  inherited DropDown;
end;

function TRDDBComboBox.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TRDDBComboBox.SetDataSource(Value: TDataSource);
begin
  if not(FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
end;

function TRDDBComboBox.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TRDDBComboBox.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

function TRDDBComboBox.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TRDDBComboBox.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

function TRDDBComboBox.GetField: TField;
begin
  Result := FDataLink.Field;
end;

function TRDDBComboBox.GetPaintText: string;
var
  I: Integer;
begin
  Result := '';
  if FDataLink.Field <> nil then
  begin
    if FEnableValues then
    begin
      I := Values.IndexOf(FDataLink.Field.Text);
      if I >= 0 then
        Result := Items.Strings[I]
    end
    else
      Result := FDataLink.Field.Text;
  end;
end;

procedure TRDDBComboBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if Key in [VK_BACK, VK_DELETE] then
    if not FDataLink.Edit then
      Key := 0;
end;

procedure TRDDBComboBox.KeyPress(var Key: Char);
var
  LPrevAutoComplete: Boolean;
begin
  LPrevAutoComplete := AutoComplete;
  AutoComplete := False;
  try
    inherited KeyPress(Key);
  finally
    AutoComplete := LPrevAutoComplete;
  end;

  if (Key >= #32) and (FDataLink.Field <> nil) and
    not FDataLink.Field.IsValidChar(Key) then
  begin
    MessageBeep(0);
    Key := #0;
  end;
  case Key of
    ^H, ^V, ^X, #32 .. High(Char):
      if not FDataLink.Edit then
        Key := #0;
    #27:
      begin
        FDataLink.Reset;
        SelectAll;
      end;
    ^A:
      begin
        SelectAll;
        Key := #0;
      end;
  end;

  if AutoComplete then
    PerformAutoActions(Key);
end;

procedure TRDDBComboBox.EditingChange(Sender: TObject);
begin
  SetEditReadOnly;
end;

procedure TRDDBComboBox.SetEditReadOnly;
begin
  if (Style in [csDropDown, csSimple]) and HandleAllocated then
    SendMessage(EditHandle, EM_SETREADONLY, Ord(not FDataLink.Editing), 0);
end;

procedure TRDDBComboBox.SetEnableValues(const Value: Boolean);
begin
  if FEnableValues <> Value then
  begin
    if Value and (Style in [csDropDown, csSimple]) then
      Style := csDropDownList;
    FEnableValues := Value;
    DataChange(Self);
  end;
end;

procedure TRDDBComboBox.WndProc(var Message: TMessage);

  procedure DrawComboBox(DC: HDC; AText: String);
  var
    R, ItemR: TRect;
    Details: TThemedElementDetails;
    FCanvas: TCanvas;
    TextColor: TColor;
    PPI: Integer;
    LStyle: TCustomStyleServices;
  begin
    R := Rect(0, 0, Width, Height);
    LStyle := StyleServices(Self);
    if Enabled then
      Details := LStyle.GetElementDetails(tcBorderNormal)
    else
      Details := LStyle.GetElementDetails(tcBorderDisabled);
    LStyle.DrawElement(DC, Details, R);
    if not LStyle.GetElementColor(Details, ecTextColor, TextColor) then
      TextColor := LStyle.GetSystemColor(clWindowText);
    R := ClientRect;
    InflateRect(R, -2, -2);
    if BiDiMode <> bdRightToLeft then
      R.Left := Succ(R.Right - GetSystemMetrics(SM_CXVSCROLL))
    else
      R.Right := Pred(R.Left + GetSystemMetrics(SM_CXVSCROLL));
    if Enabled then
      Details := LStyle.GetElementDetails(tcDropDownButtonNormal)
    else
      Details := LStyle.GetElementDetails(tcDropDownButtonDisabled);

    if CheckPerMonitorV2SupportForWindow(Handle) then
      PPI := FCurrentPPI
    else
      PPI := 0;

    LStyle.DrawElement(DC, Details, R, nil, PPI);
    if AText <> '' then
    begin
      ItemR := ClientRect;
      InflateRect(ItemR, -3, -3);
      if BiDiMode <> bdRightToLeft then
      begin
        ItemR.Right := Pred(R.Left);
        if Style <> csDropDown then
          Inc(ItemR.Left, 2);
      end
      else
      begin
        ItemR.Left := R.Right + 1;
        if Style <> csDropDown then
          Dec(ItemR.Right, 2);
      end;
      FCanvas := TCanvas.Create;
      FCanvas.Handle := DC;
      try
        FCanvas.Font := Self.Font;
        FCanvas.Font.Color := TextColor;
        FCanvas.Brush.Style := bsClear;
        FCanvas.TextOut(ItemR.Left, ItemR.Top, AText);
      finally
        FCanvas.Handle := 0;
        FCanvas.Free;
      end;
    end;
  end;

var
  S: String;
begin
  if not(csDesigning in ComponentState) then
    case Message.Msg of
      WM_COMMAND:
        if TWMCommand(Message).NotifyCode = CBN_SELCHANGE then
          if not FDataLink.Edit then
          begin
            if Style <> csSimple then
              PostMessage(Handle, CB_SHOWDROPDOWN, 0, 0);
            Exit;
          end;
      CB_SHOWDROPDOWN:
        if Message.WParam <> 0 then
          FDataLink.Edit
        else
          if not FDataLink.Editing then
          DataChange(Self); { Restore text }
      WM_CREATE,
        WM_WINDOWPOSCHANGED,
        CM_FONTCHANGED:
        if Assigned(FPaintControl) then
          FPaintControl.DestroyHandle;
    end;

  if (Message.Msg = WM_PAINT) and (csPaintCopy in ControlState) and
    IsCustomStyleActive and (seClient in StyleElements) then
  begin
    if FDataLink.Field <> nil then
      S := FDataLink.Field.Text
    else
      S := '';
    if (Style <> csDropDown) and (Items.IndexOf(S) = -1) then
      S := '';
    DrawComboBox(TWMPaint(Message).DC, S);
  end
  else
    inherited WndProc(Message);
end;

procedure TRDDBComboBox.ComboWndProc(var Message: TMessage; ComboWnd: HWnd;
  ComboProc: Pointer);
begin
  if not(csDesigning in ComponentState) then
    case Message.Msg of
      WM_LBUTTONDOWN:
        if (Style = csSimple) and (ComboWnd <> EditHandle) then
          if not FDataLink.Edit then
            Exit;
      WM_PASTE, WM_CUT, WM_UNDO, WM_CLEAR:
        if not FDataLink.Edit then
          Exit;
    end;
  inherited ComboWndProc(Message, ComboWnd, ComboProc);
end;

procedure TRDDBComboBox.CMEnter(var Message: TCMEnter);
begin
  inherited;
  if FDataLink.CanModify then
    SendMessage(EditHandle, EM_SETREADONLY, Ord(False), 0);
end;

procedure TRDDBComboBox.CMExit(var Message: TCMExit);
begin
  try
    FDataLink.UpdateRecord;
  except
    SelectAll;
    SetFocus;
    raise;
  end;
  inherited;
end;

procedure TRDDBComboBox.WMPaint(var Message: TWMPaint);
var
  S: string;
  R: TRect;
  P: TPoint;
  Child: HWnd;
begin
  if csPaintCopy in ControlState then
  begin
    if FDataLink.Field <> nil then
      S := FDataLink.Field.Text
    else
      S := '';
    if Style = csDropDown then
    begin
      SendMessage(FPaintControl.Handle, WM_SETTEXT, 0, Winapi.Windows.LPARAM(PChar(S)));
      SendMessage(FPaintControl.Handle, WM_PAINT, Message.DC, 0);
      Child := GetWindow(FPaintControl.Handle, GW_CHILD);
      if Child <> 0 then
      begin
        Winapi.Windows.GetClientRect(Child, R);
        Winapi.Windows.MapWindowPoints(Child, FPaintControl.Handle, R.TopLeft, 2);
        GetWindowOrgEx(Message.DC, P);
        SetWindowOrgEx(Message.DC, P.X - R.Left, P.Y - R.Top, nil);
        IntersectClipRect(Message.DC, 0, 0, R.Right - R.Left, R.Bottom - R.Top);
        SendMessage(Child, WM_PAINT, Message.DC, 0);
      end;
    end
    else
    begin
      SendMessage(FPaintControl.Handle, CB_RESETCONTENT, 0, 0);
      if Items.IndexOf(S) <> -1 then
      begin
        SendMessage(FPaintControl.Handle, CB_ADDSTRING, 0, Winapi.Windows.LPARAM(PChar(S)));
        SendMessage(FPaintControl.Handle, CB_SETCURSEL, 0, 0);
      end;
      SendMessage(FPaintControl.Handle, WM_PAINT, Message.DC, 0);
    end;
  end
  else
    inherited;
end;

procedure TRDDBComboBox.SetItems(const Value: TStrings);
begin
  inherited SetItems(Value);
  DataChange(Self);
end;

procedure TRDDBComboBox.SetStyle(Value: TComboboxStyle);
begin
  if (Value in [csSimple, csDropDown]) and (FEnableValues) then
    FEnableValues := False;
  if (Value = csSimple) and Assigned(FDataLink) and FDataLink.DataSourceFixed then
    DatabaseError(SNotReplicatable);
  inherited SetStyle(Value);
end;

procedure TRDDBComboBox.SetValues(const Value: TStrings);
begin
  FValues.Assign(Value);
end;

function TRDDBComboBox.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TRDDBComboBox.ValuesChanged(Sender: TObject);
begin
  if FEnableValues then
    DataChange(Self);
end;

procedure TRDDBComboBox.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Winapi.Windows.LRESULT(FDataLink);
end;

function TRDDBComboBox.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TRDDBComboBox.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

end.
