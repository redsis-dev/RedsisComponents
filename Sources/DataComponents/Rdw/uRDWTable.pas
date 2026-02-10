unit uRDWTable;

interface

uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, uDWDataset, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, uDWConstsData, uRESTDWPoolerDB,
  uDWAbout;

type
  TRDTableCustom = class(TRESTDWTable)
  end;


implementation

{ TRDTableCustom }

end.
