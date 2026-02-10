unit uLib;

interface

uses
  System.Classes;

type
  TRDLib = class
  public
    class function SeparateBlock(AText: AnsiString; AFirst, ALast: string; AKeepDelimiters: Boolean = False): string;
    class function SQLAdapter(ASQL: string; ADriver, AConexao: string): string;
  end;

implementation

uses
  System.SysUtils;

{ TRDLib }

class function TRDLib.SeparateBlock(AText: AnsiString; AFirst, ALast: string; AKeepDelimiters: Boolean): string;
var
  iFirst, iLast: Integer;
  xFirst, xLast: string;
begin
  xFirst := AFirst;
  xLast := ALast;
  AFirst := UpperCase(AFirst);
  iFirst := Pos(AFirst, UpperCase(AText)) + Length(AFirst);

  if iFirst <= 0 then
  begin
    Result := '';
    Exit;
  end;

  ALast := UpperCase(ALast);
  iLast := Pos(ALast, UpperCase(Copy(AText, iFirst, Length(AText)))) + Pred(iFirst);

  if (iFirst = 0) or (iLast = 0) or (iLast <= iFirst) then
    Result := ''
  else
  begin
    Result := Copy(AText, iFirst, iLast - iFirst);

    if AKeepDelimiters then
      Result := xFirst + Result + xLast;
  end;
end;

class function TRDLib.SQLAdapter(ASQL: string; ADriver, AConexao: string): string;
begin
  try
    if ADriver = '' then
       ADriver := 'FB';

    if not (Uppercase(ADriver) = 'MYSQL') then
    begin
      ASQL := StringReplace(ASQL, '"', #39, [rfReplaceAll]);
    end;

    Result := ASQL;
  except
    Result := '';
  end;
end;

end.
