
#ifndef PARACL_DRIVER_HH
#define PARACL_DRIVER_HH

#include <fstream>
#include <iostream>
#include <vector>

#include "../parser/parser.hh"

#ifndef yyFlexLexer
#include <FlexLexer.h>
#endif /* yyFlexLexer */

#ifndef yyFlexLexer
//#include "../FB_BLD/lex.yy.cc"
#endif /* yyFlexLexer */

//! #include "numgrammar.tab.hh" - auto generated file from bison

namespace yy
{
class Driver final
{
private:
  const char *name_of_file_;
  std::ifstream in_file;

  OurFlexLexer *plex_; // maybe this is good name
  std::vector<std::string> line_of_prog;

public:
  Driver(const char *name_of_file);

  Driver(const Driver &drvr) = delete;
  Driver &operator=(const Driver &) = delete;

  Driver(Driver &&drvr) = delete;

  bool parse();
  parser::token_type yylex(parser::semantic_type *yylval, parser::location_type *yylloc);

  /*void report_syntax_error(const parser::context &ctx);*/

  ~Driver();
};

} // namespace yy

#endif // PARACL_DRIVER_HH
