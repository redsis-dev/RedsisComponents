unit uDateTimePicker.Interpose;

interface

uses
  System.Classes,
  System.SysUtils,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Winapi.Messages;

type
  TDateTimePicker = class(Vcl.ComCtrls.TDateTimePicker)
  protected
    procedure Change; override;
  private
    FMoveCursor: Boolean;
    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
  end;

implementation

{ TDateTimePicker }

procedure TDateTimePicker.Change;
const
  CDtSep = '/';
var
  FEdit: TCustomEdit;
begin
  inherited;
  if not DroppedDown then
    if DateFormat = dfShort then
      if Format.Contains(CDtSep) then
        if FMoveCursor then
        begin
          FEdit := TCustomEdit(Self);
          if Trim(FEdit.Text)[FEdit.SelStart + 3] = CDtSep then
            Self.Perform($0100, $27, 0);
        end;
end;

procedure TDateTimePicker.WMKeyDown(var Message: TWMKeyDown);
begin
  if not DoKeyDown(Message) then
    inherited;
  UpdateUIState(Message.CharCode);
  FMoveCursor := Message.CharCode in [96 .. 105];
end;

end.
