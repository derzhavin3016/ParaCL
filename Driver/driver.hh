
#ifndef PARACL_DRIVER_HH
#define PARACL_DRIVER_HH

//#include <FlexLexer.h> // it says me about error : doesnt exist in computer

#include <fstream>
#include <iostream>
#include <vector>

#include "../FB_BLD/lex.yy.cc"
#include "../parser/parser.hh"

namespace yy
{
class Driver final
{
  private:
    const char *name_of_file_;
    OurFlexLexer *plex_; // maybe this is good name
    std::vector<std::string> line_of_prog;

  public:
    Driver();
    Driver(const char *name_of_file);

    bool parse();
    parser::token_type yylex(parser::semantic_type *yylval, parser::location_type *yylloc);

    ~Driver();
};

} // namespace yy

#endif // PARACL_DRIVER_HH
