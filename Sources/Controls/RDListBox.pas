unit RDListBox;

interface

uses
  System.Classes, FMX.ListBox, FMX.Gestures, FMX.Types, FMX.Ani, FMX.Layouts,
  FMX.Objects, System.SysUtils, FMX.StdCtrls, FMX.Graphics;

type
  TRDListBox = class(TListBox)
  protected
    function GetDefaultStyleLookupName: string; override;
  private
    FCanPullRefresh: Boolean;
    FOnPullRefresh: TNotifyEvent;
    FRDGesture: TCustomGestureManager;
    FAniPullRefresh, FAniLoading: TFloatAnimation;
    FLayoutRefresh, FLayNenhum: TLayout;
    FLabelNenhum: TLabel;
    FPathNenhum: TPath;
    FArcRefresh: TArc;
    FPathData: TPathData;
    FTextoNenhumItem: string;
    FLoadContainer: TFMXObject;
    procedure TerminateRefresh;
    procedure AniPullRefreshFinish(Sender: TObject);
    procedure PullRefreshGesture(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure DoPullRefresh(Sender: TObject);
  public
    procedure DoBeginUpdate; override;
    procedure DoEndUpdate; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property CanPullRefresh: Boolean read FCanPullRefresh write FCanPullRefresh default False;
    property OnPullRefresh: TNotifyEvent read FOnPullRefresh write FOnPullRefresh;
    property TextoNenhumItem: string read FTextoNenhumItem write FTextoNenhumItem;
    property PathData: TPathData read FPathData write FPathData;
    property LoadContainer: TFMXObject read FLoadContainer write FLoadContainer;
  end;

implementation

uses
  System.UITypes;

{ TRDListBox }

procedure TRDListBox.AniPullRefreshFinish(Sender: TObject);
begin
  FAniLoading.Start;
  FLayoutRefresh.Visible := True;
  DoPullRefresh(Sender);
end;

constructor TRDListBox.Create(AOwner: TComponent);
begin
  inherited;
  CanPullRefresh := False;

  if FRDGesture = nil then
    FRDGesture := TGestureManager.Create(Self);
  Touch.GestureManager := FRDGesture;
  Touch.StandardGestures := [TStandardGesture.sgDown];
  OnGesture := PullRefreshGesture;

  if FPathData = nil then
    FPathData := TPathData.Create;

  if FLayoutRefresh = nil then
    FLayoutRefresh := TLayout.Create(Self);
  FLayoutRefresh.Visible := False;
  FLayoutRefresh.Align := TAlignLayout.Top;
  FLayoutRefresh.Margins.Top := 10;
  FLayoutRefresh.Height := 40;

  if FArcRefresh = nil then
    FArcRefresh := TArc.Create(Self);
  FArcRefresh.Parent := FLayoutRefresh;
  FArcRefresh.Align := TAlignLayout.Center;
  FArcRefresh.Height := 30;
  FArcRefresh.Width := 30;
  FArcRefresh.EndAngle := 280;
  FArcRefresh.Fill.Kind := TBrushKind.None;
  FArcRefresh.Stroke.Color := TAlphaColorRec.Dimgray;
  FArcRefresh.Stroke.Thickness := 2;

  if FAniPullRefresh = nil then
    FAniPullRefresh := TFloatAnimation.Create(Self);
  FAniPullRefresh.Parent := Self;
  FAniPullRefresh.StopValue := 60;
  FAniPullRefresh.PropertyName := 'Content.Position.Y';
  FAniPullRefresh.Interpolation := TInterpolationType.Back;
  FAniPullRefresh.AnimationType := TAnimationType.Out;
  FAniPullRefresh.Duration := 0.5;
  FAniPullRefresh.OnFinish := AniPullRefreshFinish;

  if FAniLoading = nil then
    FAniLoading := TFloatAnimation.Create(Self);
  FAniLoading.Parent := FArcRefresh;
  FAniLoading.StopValue := 360;
  FAniLoading.PropertyName := 'RotationAngle';
  FAniLoading.Interpolation := TInterpolationType.Linear;
  FAniLoading.AnimationType := TAnimationType.InOut;
  FAniLoading.Duration := 0.8;
  FAniLoading.Loop := True;

  if FLayNenhum = nil then
    FLayNenhum := TLayout.Create(Self);
  FLayNenhum.Parent := Self;
  FLayNenhum.Visible := False;
  FLayNenhum.Align := TAlignLayout.Client;
  FLayNenhum.Margins.Top := 20;

  if FPathNenhum = nil then
    FPathNenhum := TPath.Create(Self);
  FPathNenhum.Parent := FLayNenhum;
  FPathNenhum.Data.Data := FPathData.Data;
  FPathNenhum.Stroke.Kind := TBrushKind.None;
  FPathNenhum.Fill.Color := TAlphaColorRec.Darkgray;
  FPathNenhum.Align := TAlignLayout.MostTop;
  FPathNenhum.WrapMode := TPathWrapMode.Fit;
  FPathNenhum.Height := 100;

  if FLabelNenhum = nil then
    FLabelNenhum := TLabel.Create(Self);
  FLabelNenhum.Parent := FLayNenhum;
  FLabelNenhum.Align := TAlignLayout.Top;
  FLabelNenhum.Margins.Top := 10;
  FLabelNenhum.StyledSettings := FLabelNenhum.StyledSettings - [TStyledSetting.FontColor];
  FLabelNenhum.TextSettings.FontColor := TAlphaColorRec.Darkgray;
  FLabelNenhum.TextSettings.HorzAlign := TTextAlign.Center;
  FLabelNenhum.TextSettings.Font.Size := 12;
  FLabelNenhum.TextSettings.WordWrap := True;
  FLabelNenhum.Height := 20;
end;

destructor TRDListBox.Destroy;
begin
  FreeAndNil(FPathData);
  inherited;
end;

procedure TRDListBox.DoBeginUpdate;
begin
  inherited;
  FLayNenhum.Visible := False;
end;

procedure TRDListBox.DoEndUpdate;
begin
  inherited;
  TerminateRefresh;
end;

procedure TRDListBox.DoPullRefresh(Sender: TObject);
begin
  if Assigned(FOnPullRefresh) then
    FOnPullRefresh(Sender);
end;

function TRDListBox.GetDefaultStyleLookupName: string;
begin
  Result := 'transparentlistboxstyle';
end;

procedure TRDListBox.PullRefreshGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  if (EventInfo.GestureID = sgiDown)
    and (TListBox(Sender).Content.Position.Y = 0)
    and (CanPullRefresh) then
  begin
    FLayoutRefresh.Parent := FLoadContainer;
    FAniPullRefresh.Start;
  end;
end;

procedure TRDListBox.TerminateRefresh;
begin
  FLayoutRefresh.Visible := False;
  FAniLoading.Stop;
//  if Items.Count = 0 then
//  begin
//    FLabelNenhum.Text := FTextoNenhumItem;
//    FPathNenhum.Data.Data := FPathData.Data;
//    FLayNenhum.Visible := True;
//  end
//  else
//  begin
    FLayNenhum.Visible := False;
//  end;
end;

end.
