{$IFDEF VER150}  // delphi 7

// {$UNDEF FDC}
{$DEFINE IBX}

{$ELSE} // versoes atuais do delphi

// Conexao
{$DEFINE FDC}
{.$DEFINE IBX}
{.$DEFINE RDW}

// framework
{$DEFINE VCL}
{.$DEFINE FMX}

{$ENDIF}
