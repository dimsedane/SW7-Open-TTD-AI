class SW7AI extends AIInfo 
{
    function GetAuthor()        { return "Michael Lisby (green-devil), Anders Frandsen, Rune Jensen"; }
    function GetName()          { return "SW7AI"; }
    function GetDescription()   { return "A bus network builder"; }
    function GetVersion()       { return 1; }
    function MinVersionToLoad() { return 1; }
    function GetDate()          { return "2011-09-12"; }
    function GetShortName()     { return "SW7A"; }
    function CreateInstance()   { return "SW7AI"; }
    function GetAPIVersion()    { return "1.2"; }
}
RegisterAI(SW7AI());