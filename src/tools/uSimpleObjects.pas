Unit uSimpleObjects;

Interface

type
   TIntObj = class
   private
      FI: Integer;
   public
      property I: Integer Read FI;
      constructor Create(IValue: Integer);
   end;

type
   TDateTimeObject = class(TObject)
   private
      FDT: TDateTime;
   public
      property DT: TDateTime Read FDT;
      constructor Create(DTValue: TDateTime);
   end;

Implementation

{ TIntObj }

constructor TIntObj.Create(IValue: Integer);
begin
   Inherited Create;
   FI := IValue;
end;

{ TDateTimeObject }

constructor TDateTimeObject.Create(DTValue: TDateTime);
begin
   Inherited Create;
   FDT := DTValue;
end;

end.