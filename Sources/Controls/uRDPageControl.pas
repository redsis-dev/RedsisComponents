unit uRDPageControl;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.ComCtrls;

type
  TRDPageControl = class(TPageControl)
  private
    FMostrarAbas: Boolean;
    procedure SetMostrarAbas(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property MostrarAbas: Boolean read FMostrarAbas write SetMostrarAbas default True;
  end;

implementation

{ TRDPageControl }

constructor TRDPageControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMostrarAbas := True;
end;

procedure TRDPageControl.SetMostrarAbas(const Value: Boolean);
begin
  FMostrarAbas := Value;
  for var i := 0 to PageCount -1 do
    Pages[i].TabVisible := Value;
end;

end.
