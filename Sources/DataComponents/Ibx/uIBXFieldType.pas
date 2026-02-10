unit uIBXFieldType;

interface

uses
  Classes, DB{$IFDEF VER150}, IBCustomDataSet{$ELSE}, IBX.IBCustomDataSet{$ENDIF};
type
  TRDStringFieldCustom = TIBStringField;
  TRDDateTimeFieldCustom = TDateTimeField;

implementation

end.

