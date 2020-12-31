/ forked from https://github.com/jonathonmcmurray/qwebapi/blob/master/webapi/api.q


\d .rest

funcs:([func:`$()];defaults:();required:();methods:())                              //config of funcs
define:{[f;d;r;m]funcs[f]:`defaults`required`methods!(d;(),r;$[`~m;`POST`GET;(),m])} //function to define an API function

ret:$[.z.K>=3.7;{.h.hy[1b;x;-35!(6;y)]};.h.hy];

xc:{[m;f;x] /m- HTTP method,f - function name (sym), x - arguments
  /* execute given function with arguments, error trap & return result as JSON */
  if[not f in key funcs;:.j.j "Invalid function"];                             //error on invalid functions
  if[not m in funcs[f;`methods];:.j.j "Invalid method for this function"];     //error on invalid method
  if[count a:funcs[f;`required] except key x;:.j.j "Missing required param(s): "," "sv string a]; //error on missing required params
  p:value[value f][1];                                                              //function params
  x:.Q.def[funcs[f;`defaults]]x;                                               //default values/types for args
  :.[{.j.j x . y};(value f;value p#x);{.j.j enlist[`error]!enlist x}];              //error trap, build JSON for fail
 }

dec:{[x]
  :(!/)"S=&"0:.h.uh ssr[x;"+";" "];                                                 //parse incoming request into dict, replace escaped chars
  }

ty:@[.h.ty;`form;:;"application/x-www-form-urlencoded"]                             //add type for url encoded form, used for slash commands
ty:@[ty;`json;:;"application/json"]    

prs:ty[`json`form]!(.j.k;dec)                                             //parsing functions based on Content-Type
getf:{`$first "?"vs first " "vs x 0}                                                //function name from raw request
spltp:{0 1_'(0,first ss[x 0;" "])cut x 0}                                           //split POST body from params
prms:{dec last "?"vs x 0}                                                      //parse URL params into kdb dict

.z.ph:{[x] /x - (request;headers)
  /* HTTP GET handler */
  :ret[`json] xc[`GET;getf x;prms x];                                               //run function & return as JSON
 }

.z.pp:{[x] /x - (request;headers)
  /* HTTP POST handler */
  b:spltp x;                                                                        //split POST body from params
  x[1]:lower[key x 1]!value x 1;                                                    //lower case keys
  a:prs[x[1]`$"content-type"]b[1];                                                  //parse body depending on Content-Type
  if[99h<>type a;a:()];                                                             //if body doesn't parse to dict, ignore
  a:@[a;where 10<>type each a;string];                                              //string non-strings for .Q.def
  :ret[`json] xc[`POST;getf x;a,prms b];                                            //run function & return as JSON
 }





