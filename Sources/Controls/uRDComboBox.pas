unit uRDComboBox;

interface

uses
  System.Classes, Vcl.DBCtrls, Vcl.StdCtrls, Winapi.Windows, Winapi.Messages,
  Vcl.Controls;

type
  TRDComboBox = class(TComboBox)
  private
    FEnableValues: Boolean;
    FValues: TStrings;
    procedure SetEnableValues(const Value: Boolean);
    procedure SetValues(const Value: TStrings);
    function GetValue: string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear; override;
  published
    property EnableValues: Boolean read FEnableValues write SetEnableValues default True;
    property Values: TStrings read FValues write SetValues;
    property Value: string read GetValue;
  end;

implementation

{ TRDComboBox }

procedure TRDComboBox.Clear;
begin
  inherited;
  Items.Clear;
  Values.Clear;
end;

constructor TRDComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FValues := TStringList.Create;
  FEnableValues := True;
  Style := csDropDownList;
end;

destructor TRDComboBox.Destroy;
begin
  FValues.Free;
  inherited Destroy;
end;

function TRDComboBox.GetValue: string;
begin
  if (ItemIndex > -1) and (FValues.Count > 0) then
    Result := FValues[Self.ItemIndex]
  else
    Result := '';
end;

procedure TRDComboBox.SetEnableValues(const Value: Boolean);
begin
  if FEnableValues <> Value then
  begin
    if Value and (Style in [csDropDown, csSimple]) then
      Style := csDropDownList;
    FEnableValues := Value;
  end;
end;

procedure TRDComboBox.SetValues(const Value: TStrings);
begin
  FValues.Assign(Value);
end;

end.
