unit uRDWDataset;

interface

uses
  uRDWQuery, System.Classes;

type
  TRDDataSetCustom = class(TRDQueryCustom)
  private
    function GetSelectSQL: TStrings;
    procedure SetSelectSQL(const Value: TStrings);
  published
    property SelectSQL: TStrings read GetSelectSQL write SetSelectSQL;
  end;

implementation

{ TRDDataSetCustom }

function TRDDataSetCustom.GetSelectSQL: TStrings;
begin
  Result := SQL;
end;

procedure TRDDataSetCustom.SetSelectSQL(const Value: TStrings);
begin
  SQL.Text := Value.Text;
end;

end.
