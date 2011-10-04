/* ****************************************************************************
 * Copyright (C) 2011 Alex Norton                                             *
 *                                                                            *
 * This program is free software; you can redistribute it and/or modify it    *
 * under the terms of the BSD 2-Clause License.                               *
 *                                                                            *
 * This program is distributed in the hope that it will be useful, but        *
 * WITHOUT ANY WARRENTY; without even the implied warranty of                 *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                       *
 **************************************************************************** */
 
%{

#include <objstream.hpp>
using namespace obj;

#include <iostream>
#include <sstream>
#include <string>
#include <vector>

extern int yylex();
extern int yyline;
extern int yyposs;

std::string        objn = "default";
std::vector<int>   verts;
std::vector<int>   texts;
std::vector<int>   norms;
std::istringstream istr;

int    store;

void yyerror(const char* msg) {
  std::cout << msg << std::endl;
}

%}

%union {
  char str_t[256];
}

%token         ROTATE TRANSLATE SCALE ARBITRARY
%token         VERTEX TEXTURE NORMAL
%token         GROUP
%token         FACE
%token         SLASH
%token         OBJF
%token         MTL
%token         MTLLIB
%token <str_t> NUM_LIT
%token <str_t> STRING_LIT

%type <str_t> model
%type <str_t> stmt
%type <str_t> stmtlist
%type <str_t> expr
%type <str_t> exprlist

%start model

%% /* Grammar rules and actions */

model:
    stmtlist
  | /* epsilon */
;

stmtlist:
    stmtlist stmt
  | stmt
;

stmt:
    VERTEX NUM_LIT NUM_LIT NUM_LIT
    { (*dest)[objn].push_v(objstream::vertex(atof($2), atof($3), atof($4))); }
    
  | VERTEX NUM_LIT NUM_LIT NUM_LIT NUM_LIT
    { (*dest)[objn].push_v(
         objstream::vertex(atof($2), atof($3), atof($4), atof($5))); }
    
  | TEXTURE NUM_LIT NUM_LIT
    { (*dest)[objn].push_t(objstream::texture(atof($2), atof($3))); }
    
  | NORMAL NUM_LIT NUM_LIT NUM_LIT
    { (*dest)[objn].push_n(objstream::vertex(atof($2), atof($3), atof($4))); }
    
  | FACE
    { verts.clear(); texts.clear(); norms.clear(); }
    exprlist
    { (*dest)[objn].push_f(objstream::face(verts, texts, norms, "")); }
  
  | ROTATE STRING_LIT NUM_LIT NUM_LIT NUM_LIT NUM_LIT
    { (*dest)[$2].push_m(
         new objstream::rotate(atof($3), atof($4), atof($5), atof($6))); }
    
  | TRANSLATE STRING_LIT NUM_LIT NUM_LIT NUM_LIT
    { (*dest)[$2].push_m(
         new objstream::translate(atof($3), atof($4), atof($5))); }
  
  | SCALE STRING_LIT NUM_LIT NUM_LIT NUM_LIT
    { (*dest)[$2].push_m(
         new objstream::scale(atof($3), atof($4), atof($5))); }
  
  | ARBITRARY STRING_LIT NUM_LIT NUM_LIT NUM_LIT NUM_LIT
                         NUM_LIT NUM_LIT NUM_LIT NUM_LIT
                         NUM_LIT NUM_LIT NUM_LIT NUM_LIT
                         NUM_LIT NUM_LIT NUM_LIT NUM_LIT
    {
      objstream::arbitrary* ar = new objstream::arbitrary();
      (*ar)[0][0] = atof($3);  (*ar)[0][1] = atof($4);  (*ar)[0][2] = atof($5);  (*ar)[0][3] = atof($6);
      (*ar)[1][0] = atof($7);  (*ar)[1][1] = atof($8);  (*ar)[1][2] = atof($9);  (*ar)[1][3] = atof($10);
      (*ar)[2][0] = atof($11); (*ar)[2][1] = atof($12); (*ar)[2][2] = atof($13); (*ar)[2][3] = atof($14);
      (*ar)[3][0] = atof($15); (*ar)[3][1] = atof($16); (*ar)[3][2] = atof($17); (*ar)[3][3] = atof($18);
      (*dest)[$2].push_m(ar);
    }
    
  | MTLLIB STRING_LIT
    {  }
    
  | MTL STRING_LIT
    {  }
    
  | GROUP STRING_LIT
    { objn = $2; }
;

exprlist:
    exprlist expr
  | expr
;

expr:
    NUM_LIT
    { store = atoi($1); verts.push_back(store); }
  | NUM_LIT SLASH NUM_LIT
    { store = atoi($1); verts.push_back(store);
      store = atoi($3); texts.push_back(store); }
  | NUM_LIT SLASH NUM_LIT SLASH NUM_LIT
    { store = atoi($1); verts.push_back(store);
      store = atoi($3); texts.push_back(store);
      store = atoi($5); norms.push_back(store); }
  | NUM_LIT SLASH SLASH NUM_LIT
  	{ store = atoi($1); verts.push_back(store);
  	  store = atoi($4); norms.push_back(store); }
;

%%



