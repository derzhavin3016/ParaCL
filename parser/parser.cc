//
// Created by anon on 21.02.2021.
//

#include "parser.hh"

OurFlexLexer::OurFlexLexer() : cur_location_({})
{
}

yy::location OurFlexLexer::get_cur_location()
{
  return cur_location_;
}

std::string OurFlexLexer::get_cur_str_()
{
  return cur_str_;
}

void upd_cur_loc()
{
}
