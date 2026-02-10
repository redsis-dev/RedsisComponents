unit uIBXTable;

{$I Redsis.inc}

interface

uses
  Classes, SysUtils, uRDConnection {$IFDEF VER150}, IBDatabase, IBTable{$ELSE}, IBX.IBDatabase, IBX.IBTable{$ENDIF};

type
  TUpdateOptions = class(TPersistent)
  private
    FUpdateTableName: String;
    procedure SetUpdateTableName(const Value: String);
  public
    procedure Assign(Source: TPersistent); override;
  published
    property UpdateTableName: String read FUpdateTableName write SetUpdateTableName;
  end;

  TRDMemTableCustom = class(TIBTable)
  private
    FConnection: TRDConnection;
    FUpdateOptions: TUpdateOptions;
    procedure SetConnection(const Value: TRDConnection);
    procedure SetUpdateOptions(const Value: TUpdateOptions);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    property Connection: TRDConnection read FConnection write SetConnection;
    property UpdateOptions: TUpdateOptions read FUpdateOptions write SetUpdateOptions;
  end;

implementation

{ TRDTableCustom }

constructor TRDMemTableCustom.Create(AOwner: TComponent);
begin
  FUpdateOptions := TUpdateOptions.Create;
  inherited;
end;

destructor TRDMemTableCustom.Destroy;
begin
  FreeAndNil(FUpdateOptions);
  inherited;
end;

procedure TRDMemTableCustom.SetConnection(const Value: TRDConnection);
begin
  FConnection := Value;
  Self.Database := TIBDatabase(FConnection);
end;

procedure TRDMemTableCustom.SetUpdateOptions(const Value: TUpdateOptions);
begin
  FUpdateOptions := Value;
end;

{ TUpdateOptions }

procedure TUpdateOptions.Assign(Source: TPersistent);
begin
  inherited;
  if (Source is TUpdateOptions) then
  begin
    UpdateTableName := TUpdateOptions(Source).UpdateTableName;
    Exit;
  end;
  inherited Assign(Source);
end;

procedure TUpdateOptions.SetUpdateTableName(const Value: String);
begin
  FUpdateTableName := Value;
end;


end.

