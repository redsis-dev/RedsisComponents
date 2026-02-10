unit uRDCheckListBox;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.ComCtrls, Vcl.CheckLst;

type
  TRDCheckListBox = class(TCheckListBox)
  private
    FDelimiter: Char;
    FValues: TStrings;
    procedure SetDelimiter(const Value: Char);
    procedure SetValues(const Value: TStrings);
    function GetCheckedItems: string;
    procedure SetCheckedItems(const Value: string);
    function GetCheckedValues: string;
    procedure SetCheckedValues(const Value: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear; override;
  published
    property CheckedItems: string read GetCheckedItems write SetCheckedItems;
    property CheckedValues: string read GetCheckedValues write SetCheckedValues;
    property Delimiter: Char read FDelimiter write SetDelimiter;
    property Values: TStrings read FValues write SetValues;
  end;

implementation

uses
  System.StrUtils;

procedure TRDCheckListBox.Clear;
begin
  inherited;
  Items.Clear;
  Values.Clear;
end;

constructor TRDCheckListBox.Create(AOwner: TComponent);
begin
  inherited;
  FValues := TStringList.Create;
  FDelimiter := ',';
end;

destructor TRDCheckListBox.Destroy;
begin
  FValues.Free;
  inherited;
end;

function TRDCheckListBox.GetCheckedItems: string;
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

function TRDCheckListBox.GetCheckedValues: string;
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

procedure TRDCheckListBox.SetCheckedItems(const Value: string);
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    sl.StrictDelimiter := True;
    sl.Delimiter := FDelimiter;
    sl.DelimitedText := Value;

    for var i := 0 to Pred(Items.Count) do
      Checked[i] := sl.IndexOf(Items[i]) >= 0;
  finally
    sl.Free;
  end;
end;

procedure TRDCheckListBox.SetCheckedValues(const Value: string);
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    sl.StrictDelimiter := True;
    sl.Delimiter := FDelimiter;
    sl.DelimitedText := Value;

    for var i := 0 to Pred(Values.Count) do
      Checked[i] := sl.IndexOf(Values[i]) >= 0;
  finally
    sl.Free;
  end;
end;

procedure TRDCheckListBox.SetDelimiter(const Value: Char);
begin
  FDelimiter := Value;
end;

procedure TRDCheckListBox.SetValues(const Value: TStrings);
begin
  FValues.Assign(Value);
end;

end.
