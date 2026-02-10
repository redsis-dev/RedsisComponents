unit uRDWTransaction;

interface

uses
  uRDConnection, FireDAC.Stan.Intf, FireDAC.Comp.Client, System.Classes;

type
  TAutoStopAction = (saNone, saRollback, saCommit, saRollbackRetaining, saCommitRetaining);

  TRDTransactionCustom = class(TFDTransaction)
  private
    FParams: TStringList;
    FDefaultDatabase: TRDConnection;
    FAutoStopAction: TAutoStopAction;
    FActive: Boolean;
    procedure SetActive(const Value: Boolean);
    procedure SetAutoStopAction(const Value: TAutoStopAction);
    procedure SetDefaultDatabase(const Value: TRDConnection);
    procedure SetParams(const Value: TStringList);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property AutoStopAction: TAutoStopAction read FAutoStopAction write SetAutoStopAction;
    property Active: Boolean read FActive write SetActive;
    property DefaultDatabase: TRDConnection read FDefaultDatabase write SetDefaultDatabase;
    property Params: TStringList read FParams write SetParams;
  end;

implementation

uses
  System.SysUtils;

{ TRDTransactionCustom }

constructor TRDTransactionCustom.Create(AOwner: TComponent);
begin
  inherited;
  AutoStopAction := saNone;
  FParams := TStringList.Create;
end;

destructor TRDTransactionCustom.Destroy;
begin
  FreeAndNil(FParams);
  inherited;
end;

procedure TRDTransactionCustom.SetActive(const Value: Boolean);
begin
  FActive := Value;
end;

procedure TRDTransactionCustom.SetAutoStopAction(const Value: TAutoStopAction);
begin
  FAutoStopAction := Value;
end;

procedure TRDTransactionCustom.SetDefaultDatabase(const Value: TRDConnection);
begin
  FDefaultDatabase := Value;
end;

procedure TRDTransactionCustom.SetParams(const Value: TStringList);
begin
  FParams := Value;
end;

end.
