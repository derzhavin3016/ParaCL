%language "c++"
%skeleton "lalr1.cc"

%param {Driver* driver}
%locations

%define parse.trace
%define parse.lac full

%define api.value.type variant
%define parse.error custom

%code requires
{
#include <string>
#include "../AST/INode.hh"

namespace yy
{
class Driver;
};

extern AST::IScope * CUR_SCOPE;

}

%code
{
#include "../driver/driver.hh"

namespace yy
{ parser::token_type yylex(parser::semantic_type* yylval, parser::location_type* yylloc, Driver* driver); }

extern AST::IScope * CUR_SCOPE;
}

/* some tokens */

%right ASSIGN   "="

%left

  ADD MIN
  MUL DIV MOD

  GREATER LESS
  GR_EQ LS_EQ
  IS_EQ NOT_EQ
  
  AND OR
  ;

%nonassoc

  NEG NOT
  ;

%token

  COMMA
  COLON
  SCOLON

  LP RP
  LB RB

  IF ELSE
  WHILE

  SCAN
  PRINT

  ERR
  ;

%token <int> INT
%token <std::string> NAME

/* nonterminals */

%nterm<AST::IScope *>

  scope
  cl_sc
  ;

%nterm<AST::IScope *> cur_stm

%nterm<AST::INode *> 
  stm
  stms
  ;

%nterm<AST::INode *>

  if
  while
  print
  assign
  ;

%nterm<AST::INode *>

  expr
  expr_or
  expr_and
  expr_eqty
  expr_cmp
  expr_pm
  expr_mdm
  expr_un
  expr_term
  ;

%nterm<AST::Ops>

  pm
  mdm
  cmp
  eq_ty
  un
  ;

%%


program:     stms                                 { /* program starting */ };

scope:       op_sc stms cl_sc                     { $$ = $3; };

op_sc:       LB                                   { CUR_SCOPE = AST::MemMan::manager().make_scope(CUR_SCOPE); };

cl_sc:       RB                                   {
                                                    $$ = CUR_SCOPE;
                                                    CUR_SCOPE = CUR_SCOPE->reset_scope();
                                                  };

stms:        stm                                  { CUR_SCOPE->push($1); };
           | stms stm                             { CUR_SCOPE->push($2); };
           | scope                                { CUR_SCOPE->push($1); };
           | stms scope                           { CUR_SCOPE->push($2); };

cur_stm:     stm                                  {
                                                     $$ = AST::MemMan::manager().make_scope(CUR_SCOPE);
                                                     $$->push($1);
                                                  };
           | scope                                { $$ = $1; };

stm:         assign                               { $$ = $1; };
           | if                                   { $$ = $1; };
           | while                                { $$ = $1; };
           | print                                { $$ = $1; };

assign:      NAME ASSIGN expr SCOLON              { $$ = AST::MemMan::manager().make_asgn($1, $3); };

expr:        expr_or                              { $$ = $1; };

expr_or:     expr_or OR expr_and                  { $$ = AST::MemMan::manager().make_op($1, AST::Ops::OR, $3); };
           | expr_and                             { $$ = $1; };

expr_and:    expr_and AND expr_eqty               { $$ = AST::MemMan::manager().make_op($1, AST::Ops::AND, $3); };
           | expr_eqty                            { $$ = $1; };

expr_eqty:   expr_eqty eq_ty expr_cmp             { $$ = AST::MemMan::manager().make_op($1, $2, $3); };
           | expr_cmp                             { $$ = $1; };

expr_cmp:    expr_cmp cmp expr_pm                 { $$ = AST::MemMan::manager().make_op($1, $2, $3); };
           | expr_pm                              { $$ = $1; };

expr_pm:     expr_pm pm expr_mdm                  { $$ = AST::MemMan::manager().make_op($1, $2, $3); };
           | expr_mdm                             { $$ = $1; };

expr_mdm:    expr_mdm mdm expr_term               { $$ = AST::MemMan::manager().make_op($1, $2, $3); };
           | expr_un                              { $$ = $1; };

expr_un:     un expr_un                           { $$ = AST::MemMan::manager().make_un($1, $2); };
           | expr_term                            { $$ = $1; };

expr_term:   LP expr[e] RP                        { $$ = $e; };
           | NAME                                 { $$ = AST::MemMan::manager().make_ref($1); };
           | INT                                  { $$ = AST::MemMan::manager().make_cst($1); };
           | SCAN                                 { $$ = AST::MemMan::manager().make_scan(); };

if:          IF LP expr[e] RP cur_stm[s]          { $$ = AST::MemMan::manager().make_if($e, $s); };
           | IF LP expr[e] RP cur_stm[s1]                                               /* dangling else */
             ELSE cur_stm[s2]                     { $$ = AST::MemMan::manager().make_if($e, $s1, $s2); }; /* this rule creates shift-reduce conflict  */

while:       WHILE LP expr[e] RP cur_stm[s]       { $$ = AST::MemMan::manager().make_while($e, $s); };

pm:          ADD                                  { $$ = AST::Ops::ADD; }; 
           | MIN                                  { $$ = AST::Ops::SUB; }; 

mdm:         MUL                                  { $$ = AST::Ops::MUL; };  
           | DIV                                  { $$ = AST::Ops::DIV; };
           | MOD                                  { $$ = AST::Ops::MOD; };

cmp:         GREATER                              { $$ = AST::Ops::GREATER; };
           | LESS                                 { $$ = AST::Ops::LESS; };
           | GR_EQ                                { $$ = AST::Ops::GR_EQ; };
           | LS_EQ                                { $$ = AST::Ops::LS_EQ; };

eq_ty:       IS_EQ                                { $$ = AST::Ops::IS_EQ; };
           | NOT_EQ                               { $$ = AST::Ops::NOT_EQ; };

un:          MIN                                  { $$ = AST::Ops::NEG; };
           | NOT                                  { $$ = AST::Ops::NOT; };

print:       PRINT expr SCOLON                    { $$ = AST::MemMan::manager().make_print($2); };

%%

namespace yy
{

  void parser::error (const parser::location_type& location, const std::string& string)
  {
  	std::cerr << string << " in (line.column): "<< location << std::endl;
  }

  parser::token_type yylex(parser::semantic_type* yylval, parser::location_type* yylloc, Driver* driver)
  {
   	return driver->yylex(yylval, yylloc);
  }

  void parser::report_syntax_error(parser::context const& ctx) const
  {
  	driver->report_syntax_error(ctx);
  }

}

