var k=void 0,l=!0,m=null,r=!1,u,v=this;function aa(a,b){var c=a.split("."),d=v;!(c[0]in d)&&d.execScript&&d.execScript("var "+c[0]);for(var f;c.length&&(f=c.shift());)!c.length&&b!==k?d[f]=b:d=d[f]?d[f]:d[f]={}}function ba(a){a.S=function(){return a.ma?a.ma:a.ma=new a}}
function ca(a){var b=typeof a;if("object"==b)if(a){if(a instanceof Array)return"array";if(a instanceof Object)return b;var c=Object.prototype.toString.call(a);if("[object Window]"==c)return"object";if("[object Array]"==c||"number"==typeof a.length&&"undefined"!=typeof a.splice&&"undefined"!=typeof a.propertyIsEnumerable&&!a.propertyIsEnumerable("splice"))return"array";if("[object Function]"==c||"undefined"!=typeof a.call&&"undefined"!=typeof a.propertyIsEnumerable&&!a.propertyIsEnumerable("call"))return"function"}else return"null";
else if("function"==b&&"undefined"==typeof a.call)return"object";return b}function w(a){return"string"==typeof a}function y(a){return"function"==ca(a)}function da(a){var b=typeof a;return"object"==b&&a!=m||"function"==b}function A(a){return a[ea]||(a[ea]=++fa)}var ea="closure_uid_"+Math.floor(2147483648*Math.random()).toString(36),fa=0;
function ga(a,b){var c=Array.prototype.slice.call(arguments,1);return function(){var b=Array.prototype.slice.call(arguments);b.unshift.apply(b,c);return a.apply(this,b)}}function ha(a,b){function c(){}c.prototype=b.prototype;a.X=b.prototype;a.prototype=new c;a.prototype.constructor=a};function ia(a,b){this.x=a;this.y=b};function ja(a){this.points=a}function ka(a){for(var b=0,c=a.length-1,d=0;d<a.length;d++)b+=(a[c].x+a[d].x)*(a[c].y-a[d].y),c=d;return b/2}
function la(a,b){for(var c,d=c=0,f,e=a.length-1,g=0;g<a.length;g++)f=a[g].x*a[e].y-a[e].x*a[g].y,c+=(a[g].x+a[e].x)*f,d+=(a[g].y+a[e].y)*f,e=g;f=6*ka(a);c=new ia(Math.abs(c/f),Math.abs(d/f));d=[];for(f=0;f<a.length;f++){var e=a[f],h=(0>ka(a)?-1:1)*b,g=e.x-c.x,i=e.y-c.y,n=0<h?1:0>h?-1:0,h=Math.sqrt(Math.pow(h,2)/(1+Math.pow(g/i,2)));d.push({x:e.x+Math.abs(g/i*h)*(0<g?1:0>g?-1:0)*n,y:e.y+Math.abs(h)*(0<i?1:0>i?-1:0)*n})}return d};function ma(a,b,c,d){0<c?(this.x=a,this.width=c):(this.x=a+c,this.width=-c);0<d?(this.y=b,this.height=d):(this.y=b+d,this.height=-d)};function na(a,b){this.type=a;this.geometry=b}function oa(a){return"rect"==a.type?a.geometry.width*a.geometry.height:"polygon"==a.type?Math.abs(ka(a.geometry.points)):0}function pa(a,b){var c;c=a.geometry.points;var d=0>ka(c)?-1:1;if(4>c.length)c=la(c,d*b);else{for(var f=c.length-1,e=1,g=[],h=0;h<c.length;h++)f=la([c[f],c[h],c[e]],d*b),g.push(f[1]),f=h,e++,e>c.length-1&&(e=0);c=g}return new na("polygon",new ja(c))}function B(a){return JSON.stringify(a.geometry)}
window.annotorious||(window.annotorious={});window.annotorious.geometry||(window.annotorious.geometry={},window.annotorious.geometry.expand=pa);function qa(a){return a.replace(/^[\s\xa0]+|[\s\xa0]+$/g,"")}function ra(a){if(!sa.test(a))return a;-1!=a.indexOf("&")&&(a=a.replace(ta,"&amp;"));-1!=a.indexOf("<")&&(a=a.replace(ua,"&lt;"));-1!=a.indexOf(">")&&(a=a.replace(va,"&gt;"));-1!=a.indexOf('"')&&(a=a.replace(wa,"&quot;"));return a}var ta=/&/g,ua=/</g,va=/>/g,wa=/\"/g,sa=/[&<>\"]/;var C=Array.prototype,xa=C.indexOf?function(a,b,c){return C.indexOf.call(a,b,c)}:function(a,b,c){c=c==m?0:0>c?Math.max(0,a.length+c):c;if(w(a))return!w(b)||1!=b.length?-1:a.indexOf(b,c);for(;c<a.length;c++)if(c in a&&a[c]===b)return c;return-1},D=C.forEach?function(a,b,c){C.forEach.call(a,b,c)}:function(a,b,c){for(var d=a.length,f=w(a)?a.split(""):a,e=0;e<d;e++)e in f&&b.call(c,f[e],e,a)},ya=C.filter?function(a,b,c){return C.filter.call(a,b,c)}:function(a,b,c){for(var d=a.length,f=[],e=0,g=w(a)?a.split(""):
a,h=0;h<d;h++)if(h in g){var i=g[h];b.call(c,i,h,a)&&(f[e++]=i)}return f};function za(a,b){var c=xa(a,b);0<=c&&C.splice.call(a,c,1)}function Aa(a,b,c){return 2>=arguments.length?C.slice.call(a,b):C.slice.call(a,b,c)}function Ba(a,b){return a>b?1:a<b?-1:0};var E,Ca,Da,Ea,Fa;function Ga(){return v.navigator?v.navigator.userAgent:m}function Ha(){return v.navigator}Ea=Da=Ca=E=r;var Ia;if(Ia=Ga()){var Ja=Ha();E=0==Ia.indexOf("Opera");Ca=!E&&-1!=Ia.indexOf("MSIE");Da=!E&&-1!=Ia.indexOf("WebKit");Ea=!E&&!Da&&"Gecko"==Ja.product}var Ka=E,F=Ca,G=Ea,H=Da,La=Ha();Fa=-1!=(La&&La.platform||"").indexOf("Mac");var Ma=!!Ha()&&-1!=(Ha().appVersion||"").indexOf("X11"),Na;
a:{var Oa="",Pa;if(Ka&&v.opera)var Qa=v.opera.version,Oa="function"==typeof Qa?Qa():Qa;else if(G?Pa=/rv\:([^\);]+)(\)|;)/:F?Pa=/MSIE\s+([^\);]+)(\)|;)/:H&&(Pa=/WebKit\/(\S+)/),Pa)var Ra=Pa.exec(Ga()),Oa=Ra?Ra[1]:"";if(F){var Sa,Ta=v.document;Sa=Ta?Ta.documentMode:k;if(Sa>parseFloat(Oa)){Na=String(Sa);break a}}Na=Oa}var Ua={};
function I(a){var b;if(!(b=Ua[a])){b=0;for(var c=qa(String(Na)).split("."),d=qa(String(a)).split("."),f=Math.max(c.length,d.length),e=0;0==b&&e<f;e++){var g=c[e]||"",h=d[e]||"",i=RegExp("(\\d*)(\\D*)","g"),n=RegExp("(\\d*)(\\D*)","g");do{var p=i.exec(g)||["","",""],j=n.exec(h)||["","",""];if(0==p[0].length&&0==j[0].length)break;b=((0==p[1].length?0:parseInt(p[1],10))<(0==j[1].length?0:parseInt(j[1],10))?-1:(0==p[1].length?0:parseInt(p[1],10))>(0==j[1].length?0:parseInt(j[1],10))?1:0)||((0==p[2].length)<
(0==j[2].length)?-1:(0==p[2].length)>(0==j[2].length)?1:0)||(p[2]<j[2]?-1:p[2]>j[2]?1:0)}while(0==b)}b=Ua[a]=0<=b}return b}var Va={};function Wa(){return Va[9]||(Va[9]=F&&!!document.documentMode&&9<=document.documentMode)};var Xa,Ya=!F||Wa();!G&&!F||F&&Wa()||G&&I("1.9.1");F&&I("9");function Za(a){a=a.className;return w(a)&&a.match(/\S+/g)||[]}function $a(a,b){for(var c=Za(a),d=Aa(arguments,1),f=c.length+d.length,e=c,g=0;g<d.length;g++)0<=xa(e,d[g])||e.push(d[g]);a.className=c.join(" ");return c.length==f}function ab(a,b){var c=Za(a),d=Aa(arguments,1),c=ya(c,function(a){return!(0<=xa(d,a))});a.className=c.join(" ")};function bb(a,b){for(var c in a)b.call(k,a[c],c,a)}var cb="constructor hasOwnProperty isPrototypeOf propertyIsEnumerable toLocaleString toString valueOf".split(" ");function db(a,b){for(var c,d,f=1;f<arguments.length;f++){d=arguments[f];for(c in d)a[c]=d[c];for(var e=0;e<cb.length;e++)c=cb[e],Object.prototype.hasOwnProperty.call(d,c)&&(a[c]=d[c])}};function eb(a){return a?new fb(9==a.nodeType?a:a.ownerDocument||a.document):Xa||(Xa=new fb)}var gb={cellpadding:"cellPadding",cellspacing:"cellSpacing",colspan:"colSpan",frameborder:"frameBorder",height:"height",maxlength:"maxLength",role:"role",rowspan:"rowSpan",type:"type",usemap:"useMap",valign:"vAlign",width:"width"};
function hb(a,b,c){var d=arguments,f=document,e=d[0],g=d[1];if(!Ya&&g&&(g.name||g.type)){e=["<",e];g.name&&e.push(' name="',ra(g.name),'"');if(g.type){e.push(' type="',ra(g.type),'"');var h={};db(h,g);delete h.type;g=h}e.push(">");e=e.join("")}e=f.createElement(e);if(g)if(w(g))e.className=g;else if("array"==ca(g))$a.apply(m,[e].concat(g));else{var i=e;bb(g,function(a,b){"style"==b?i.style.cssText=a:"class"==b?i.className=a:"for"==b?i.htmlFor=a:b in gb?i.setAttribute(gb[b],a):0==b.lastIndexOf("aria-",
0)||0==b.lastIndexOf("data-",0)?i.setAttribute(b,a):i[b]=a})}if(2<d.length)for(var n=f,p=e,f=function(a){a&&p.appendChild(w(a)?n.createTextNode(a):a)},g=2;g<d.length;g++){var j=d[g],h=ca(j);if(("array"==h||"object"==h&&"number"==typeof j.length)&&!(da(j)&&0<j.nodeType)){var q;a:{if(j&&"number"==typeof j.length){if(da(j)){q="function"==typeof j.item||"string"==typeof j.item;break a}if(y(j)){q="function"==typeof j.item;break a}}q=r}h=D;if(q)if(q=j.length,0<q){for(var x=Array(q),t=0;t<q;t++)x[t]=j[t];
j=x}else j=[];h(j,f)}else f(j)}return e}function ib(a,b){if(a.contains&&1==b.nodeType)return a==b||a.contains(b);if("undefined"!=typeof a.compareDocumentPosition)return a==b||Boolean(a.compareDocumentPosition(b)&16);for(;b&&a!=b;)b=b.parentNode;return b==a}function fb(a){this.Q=a||v.document||document}u=fb.prototype;u.ka=function(a){return w(a)?this.Q.getElementById(a):a};u.createElement=function(a){return this.Q.createElement(a)};u.createTextNode=function(a){return this.Q.createTextNode(a)};
u.appendChild=function(a,b){a.appendChild(b)};u.contains=ib;var J;J=function(){return l};/*
 Portions of this code are from the Dojo Toolkit, received by
 The Closure Library Authors under the BSD license. All other code is
 Copyright 2005-2009 The Closure Library Authors. All Rights Reserved.

The "New" BSD License:

Copyright (c) 2005-2009, The Dojo Foundation
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.
 Neither the name of the Dojo Foundation nor the names of its contributors
    may be used to endorse or promote products derived from this software
    without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
function jb(a,b){var c=b||[];a&&c.push(a);return c}var kb=H&&"BackCompat"==document.compatMode,lb=document.firstChild.children?"children":"childNodes",K=r;
function mb(a){function b(){0<=n&&(s.id=c(n,t).replace(/\\/g,""),n=-1);if(0<=p){var a=p==t?m:c(p,t);0>">~+".indexOf(a)?s.d=a:s.G=a;p=-1}0<=i&&(s.i.push(c(i+1,t).replace(/\\/g,"")),i=-1)}function c(b,c){return qa(a.slice(b,c))}for(var a=0<=">~+".indexOf(a.slice(-1))?a+" * ":a+" ",d=[],f=-1,e=-1,g=-1,h=-1,i=-1,n=-1,p=-1,j="",q="",x,t=0,yc=a.length,s=m,z=m;j=q,q=a.charAt(t),t<yc;t++)if("\\"!=j)if(s||(x=t,s={r:m,n:[],B:[],i:[],d:m,G:m,id:m,T:function(){return K?this.Fa:this.d}},p=t),0<=f)if("]"==q){z.P?
z.V=c(g||f+1,t):z.P=c(f+1,t);if((f=z.V)&&('"'==f.charAt(0)||"'"==f.charAt(0)))z.V=f.slice(1,-1);s.B.push(z);z=m;f=g=-1}else"="==q&&(g=0<="|~^$*".indexOf(j)?j:"",z.type=g+q,z.P=c(f+1,t-g.length),g=t+1);else 0<=e?")"==q&&(0<=h&&(z.value=c(e+1,t)),h=e=-1):"#"==q?(b(),n=t+1):"."==q?(b(),i=t):":"==q?(b(),h=t):"["==q?(b(),f=t,z={}):"("==q?(0<=h&&(z={name:c(h+1,t),value:m},s.n.push(z)),e=t):" "==q&&j!=q&&(b(),0<=h&&s.n.push({name:c(h+1,t)}),s.oa=s.n.length||s.B.length||s.i.length,s.Pa=s.r=c(x,t),s.Fa=s.d=
s.G?m:s.d||"*",s.d&&(s.d=s.d.toUpperCase()),d.length&&d[d.length-1].G&&(s.la=d.pop(),s.r=s.la.r+" "+s.r),d.push(s),s=m);return d}function L(a,b){return!a?b:!b?a:function(){return a.apply(window,arguments)&&b.apply(window,arguments)}}function nb(a){return 1==a.nodeType}function M(a,b){return!a?"":"class"==b?a.className||"":"for"==b?a.htmlFor||"":"style"==b?a.style.cssText||"":(K?a.getAttribute(b):a.getAttribute(b,2))||""}
var ob={"*=":function(a,b){return function(c){return 0<=M(c,a).indexOf(b)}},"^=":function(a,b){return function(c){return 0==M(c,a).indexOf(b)}},"$=":function(a,b){return function(c){c=" "+M(c,a);return c.lastIndexOf(b)==c.length-b.length}},"~=":function(a,b){var c=" "+b+" ";return function(b){return 0<=(" "+M(b,a)+" ").indexOf(c)}},"|=":function(a,b){b=" "+b;return function(c){c=" "+M(c,a);return c==b||0==c.indexOf(b+"-")}},"=":function(a,b){return function(c){return M(c,a)==b}}},pb="undefined"==
typeof document.firstChild.nextElementSibling,qb=!pb?"nextElementSibling":"nextSibling",rb=!pb?"previousElementSibling":"previousSibling",sb=pb?nb:J;function tb(a){for(;a=a[rb];)if(sb(a))return r;return l}function ub(a){for(;a=a[qb];)if(sb(a))return r;return l}function vb(a){var b=a.parentNode,c=0,d=b[lb],f=a._i||-1,e=b._l||-1;if(!d)return-1;d=d.length;if(e==d&&0<=f&&0<=e)return f;b._l=d;f=-1;for(b=b.firstElementChild||b.firstChild;b;b=b[qb])sb(b)&&(b._i=++c,a===b&&(f=c));return f}
function wb(a){return!(vb(a)%2)}function xb(a){return vb(a)%2}
var yb={checked:function(){return function(a){return a.checked||a.attributes.checked}},"first-child":function(){return tb},"last-child":function(){return ub},"only-child":function(){return function(a){return!tb(a)||!ub(a)?r:l}},empty:function(){return function(a){for(var b=a.childNodes,a=a.childNodes.length-1;0<=a;a--){var c=b[a].nodeType;if(1===c||3==c)return r}return l}},contains:function(a,b){var c=b.charAt(0);if('"'==c||"'"==c)b=b.slice(1,-1);return function(a){return 0<=a.innerHTML.indexOf(b)}},
not:function(a,b){var c=mb(b)[0],d={q:1};"*"!=c.d&&(d.d=1);c.i.length||(d.i=1);var f=N(c,d);return function(a){return!f(a)}},"nth-child":function(a,b){if("odd"==b)return xb;if("even"==b)return wb;if(-1!=b.indexOf("n")){var c=b.split("n",2),d=c[0]?"-"==c[0]?-1:parseInt(c[0],10):1,f=c[1]?parseInt(c[1],10):0,e=0,g=-1;0<d?0>f?f=f%d&&d+f%d:0<f&&(f>=d&&(e=f-f%d),f%=d):0>d&&(d*=-1,0<f&&(g=f,f%=d));if(0<d)return function(a){a=vb(a);return a>=e&&(0>g||a<=g)&&a%d==f};b=f}var h=parseInt(b,10);return function(a){return vb(a)==
h}}},zb=F?function(a){var b=a.toLowerCase();"class"==b&&(a="className");return function(c){return K?c.getAttribute(a):c[a]||c[b]}}:function(a){return function(b){return b&&b.getAttribute&&b.hasAttribute(a)}};
function N(a,b){if(!a)return J;var b=b||{},c=m;b.q||(c=L(c,nb));b.d||"*"!=a.d&&(c=L(c,function(b){return b&&b.tagName==a.T()}));b.i||D(a.i,function(a,b){var e=RegExp("(?:^|\\s)"+a+"(?:\\s|$)");c=L(c,function(a){return e.test(a.className)});c.count=b});b.n||D(a.n,function(a){var b=a.name;yb[b]&&(c=L(c,yb[b](b,a.value)))});b.B||D(a.B,function(a){var b,e=a.P;a.type&&ob[a.type]?b=ob[a.type](e,a.V):e.length&&(b=zb(e));b&&(c=L(c,b))});b.id||a.id&&(c=L(c,function(b){return!!b&&b.id==a.id}));c||"default"in
b||(c=J);return c}var Ab={};
function Bb(a){var b=Ab[a.r];if(b)return b;var c=a.la,c=c?c.G:"",d=N(a,{q:1}),f="*"==a.d,e=document.getElementsByClassName;if(c)if(e={q:1},f&&(e.d=1),d=N(a,e),"+"==c)var g=d,b=function(a,b,c){for(;a=a[qb];)if(!pb||nb(a)){(!c||Cb(a,c))&&g(a)&&b.push(a);break}return b};else if("~"==c)var h=d,b=function(a,b,c){for(a=a[qb];a;){if(sb(a)){if(c&&!Cb(a,c))break;h(a)&&b.push(a)}a=a[qb]}return b};else{if(">"==c)var i=d,i=i||J,b=function(a,b,c){for(var d=0,e=a[lb];a=e[d++];)sb(a)&&((!c||Cb(a,c))&&i(a,d))&&b.push(a);
return b}}else if(a.id)d=!a.oa&&f?J:N(a,{q:1,id:1}),b=function(b,c){var e=eb(b).ka(a.id),f;if(f=e&&d(e))if(!(f=9==b.nodeType)){for(f=e.parentNode;f&&f!=b;)f=f.parentNode;f=!!f}if(f)return jb(e,c)};else if(e&&/\{\s*\[native code\]\s*\}/.test(String(e))&&a.i.length&&!kb)var d=N(a,{q:1,i:1,id:1}),n=a.i.join(" "),b=function(a,b){for(var c=jb(0,b),e,f=0,g=a.getElementsByClassName(n);e=g[f++];)d(e,a)&&c.push(e);return c};else!f&&!a.oa?b=function(b,c){for(var d=jb(0,c),e,f=0,g=b.getElementsByTagName(a.T());e=
g[f++];)d.push(e);return d}:(d=N(a,{q:1,d:1,id:1}),b=function(b,c){for(var e=jb(0,c),f,g=0,h=b.getElementsByTagName(a.T());f=h[g++];)d(f,b)&&e.push(f);return e});return Ab[a.r]=b}var Db={},Eb={};function Fb(a){var b=mb(qa(a));if(1==b.length){var c=Bb(b[0]);return function(a){if(a=c(a,[]))a.F=l;return a}}return function(a){for(var a=jb(a),c,e,g=b.length,h,i,n=0;n<g;n++){i=[];c=b[n];e=a.length-1;0<e&&(h={},i.F=l);e=Bb(c);for(var p=0;c=a[p];p++)e(c,i,h);if(!i.length)break;a=i}return i}}
var Gb=!!document.querySelectorAll&&(!H||I("526"));
function Hb(a,b){if(Gb){var c=Eb[a];if(c&&!b)return c}if(c=Db[a])return c;var c=a.charAt(0),d=-1==a.indexOf(" ");0<=a.indexOf("#")&&d&&(b=l);if(Gb&&!b&&-1==">~+".indexOf(c)&&(!F||-1==a.indexOf(":"))&&!(kb&&0<=a.indexOf("."))&&-1==a.indexOf(":contains")&&-1==a.indexOf("|=")){var f=0<=">~+".indexOf(a.charAt(a.length-1))?a+" *":a;return Eb[a]=function(b){try{if(!(9==b.nodeType||d))throw"";var c=b.querySelectorAll(f);F?c.Aa=l:c.F=l;return c}catch(e){return Hb(a,l)(b)}}}var e=a.split(/\s*,\s*/);return Db[a]=
2>e.length?Fb(a):function(a){for(var b=0,c=[],d;d=e[b++];)c=c.concat(Fb(d)(a));return c}}var O=0,Ib=F?function(a){return K?a.getAttribute("_uid")||a.setAttribute("_uid",++O)||O:a.uniqueID}:function(a){return a._uid||(a._uid=++O)};function Cb(a,b){if(!b)return 1;var c=Ib(a);return!b[c]?b[c]=1:0}
function Jb(a){if(a&&a.F)return a;var b=[];if(!a||!a.length)return b;a[0]&&b.push(a[0]);if(2>a.length)return b;O++;if(F&&K){var c=O+"";a[0].setAttribute("_zipIdx",c);for(var d=1,f;f=a[d];d++)a[d].getAttribute("_zipIdx")!=c&&b.push(f),f.setAttribute("_zipIdx",c)}else if(F&&a.Aa)try{for(d=1;f=a[d];d++)nb(f)&&b.push(f)}catch(e){}else{a[0]&&(a[0]._zipIdx=O);for(d=1;f=a[d];d++)a[d]._zipIdx!=O&&b.push(f),f._zipIdx=O}return b}
function Kb(a,b){if(!a)return[];if(a.constructor==Array)return a;if(!w(a))return[a];if(w(b)&&(b=w(b)?document.getElementById(b):b,!b))return[];var b=b||document,c=b.ownerDocument||b.documentElement;K=b.contentType&&"application/xml"==b.contentType||Ka&&(b.doctype||"[object XMLDocument]"==c.toString())||!!c&&(F?c.xml:b.xmlVersion||c.xmlVersion);return(c=Hb(a)(b))&&c.F?c:Jb(c)}Kb.n=yb;aa("goog.dom.query",Kb);aa("goog.dom.query.pseudos",Kb.n);!F||Wa();var Lb=!F||Wa(),Mb=F&&!I("9");!H||I("528");G&&I("1.9b")||F&&I("8")||Ka&&I("9.5")||H&&I("528");G&&!I("8")||F&&I("9");function Nb(){0!=Ob&&(this.Na=Error().stack,A(this))}var Ob=0;function P(a,b){this.type=a;this.currentTarget=this.target=b}P.prototype.W=r;P.prototype.defaultPrevented=r;P.prototype.Ha=l;P.prototype.preventDefault=function(){this.defaultPrevented=l;this.Ha=r};function Pb(a){Pb[" "](a);return a}Pb[" "]=function(){};function Qb(a,b){a&&this.init(a,b)}ha(Qb,P);u=Qb.prototype;u.target=m;u.relatedTarget=m;u.offsetX=0;u.offsetY=0;u.clientX=0;u.clientY=0;u.screenX=0;u.screenY=0;u.button=0;u.keyCode=0;u.charCode=0;u.ctrlKey=r;u.altKey=r;u.shiftKey=r;u.metaKey=r;u.Ga=r;u.k=m;
u.init=function(a,b){var c=this.type=a.type;P.call(this,c);this.target=a.target||a.srcElement;this.currentTarget=b;var d=a.relatedTarget;if(d){if(G){var f;a:{try{Pb(d.nodeName);f=l;break a}catch(e){}f=r}f||(d=m)}}else"mouseover"==c?d=a.fromElement:"mouseout"==c&&(d=a.toElement);this.relatedTarget=d;this.offsetX=H||a.offsetX!==k?a.offsetX:a.layerX;this.offsetY=H||a.offsetY!==k?a.offsetY:a.layerY;this.clientX=a.clientX!==k?a.clientX:a.pageX;this.clientY=a.clientY!==k?a.clientY:a.pageY;this.screenX=
a.screenX||0;this.screenY=a.screenY||0;this.button=a.button;this.keyCode=a.keyCode||0;this.charCode=a.charCode||("keypress"==c?a.keyCode:0);this.ctrlKey=a.ctrlKey;this.altKey=a.altKey;this.shiftKey=a.shiftKey;this.metaKey=a.metaKey;this.Ga=Fa?a.metaKey:a.ctrlKey;this.state=a.state;this.k=a;a.defaultPrevented&&this.preventDefault();delete this.W};
u.preventDefault=function(){Qb.X.preventDefault.call(this);var a=this.k;if(a.preventDefault)a.preventDefault();else if(a.returnValue=r,Mb)try{if(a.ctrlKey||112<=a.keyCode&&123>=a.keyCode)a.keyCode=-1}catch(b){}};function Rb(){}var Sb=0;u=Rb.prototype;u.key=0;u.s=r;u.ia=r;u.init=function(a,b,c,d,f,e){if(y(a))this.na=l;else if(a&&a.handleEvent&&y(a.handleEvent))this.na=r;else throw Error("Invalid listener argument");this.w=a;this.qa=b;this.src=c;this.type=d;this.capture=!!f;this.U=e;this.ia=r;this.key=++Sb;this.s=r};u.handleEvent=function(a){return this.na?this.w.call(this.U||this.src,a):this.w.handleEvent.call(this.w,a)};var Q={},R={},S={},T={};
function U(a,b,c,d,f){if(b){if("array"==ca(b)){for(var e=0;e<b.length;e++)U(a,b[e],c,d,f);return m}var d=!!d,g=R;b in g||(g[b]={j:0,o:0});g=g[b];d in g||(g[d]={j:0,o:0},g.j++);var g=g[d],h=A(a),i;g.o++;if(g[h]){i=g[h];for(e=0;e<i.length;e++)if(g=i[e],g.w==c&&g.U==f){if(g.s)break;return i[e].key}}else i=g[h]=[],g.j++;var n=Tb,p=Lb?function(a){return n.call(p.src,p.key,a)}:function(a){a=n.call(p.src,p.key,a);if(!a)return a},e=p;e.src=a;g=new Rb;g.init(c,e,a,b,d,f);c=g.key;e.key=c;i.push(g);Q[c]=g;S[h]||
(S[h]=[]);S[h].push(g);a.addEventListener?(a==v||!a.ja)&&a.addEventListener(b,e,d):a.attachEvent(b in T?T[b]:T[b]="on"+b,e);return c}throw Error("Invalid event type");}function Ub(a,b,c,d,f){if("array"==ca(b))for(var e=0;e<b.length;e++)Ub(a,b[e],c,d,f);else{d=!!d;a:{e=R;if(b in e&&(e=e[b],d in e&&(e=e[d],a=A(a),e[a]))){a=e[a];break a}a=m}if(a)for(e=0;e<a.length;e++)if(a[e].w==c&&a[e].capture==d&&a[e].U==f){V(a[e].key);break}}}
function V(a){if(Q[a]){var b=Q[a];if(!b.s){var c=b.src,d=b.type,f=b.qa,e=b.capture;c.removeEventListener?(c==v||!c.ja)&&c.removeEventListener(d,f,e):c.detachEvent&&c.detachEvent(d in T?T[d]:T[d]="on"+d,f);c=A(c);S[c]&&(f=S[c],za(f,b),0==f.length&&delete S[c]);b.s=l;if(b=R[d][e][c])b.pa=l,Vb(d,e,c,b);delete Q[a]}}}
function Vb(a,b,c,d){if(!d.D&&d.pa){for(var f=0,e=0;f<d.length;f++)d[f].s?d[f].qa.src=m:(f!=e&&(d[e]=d[f]),e++);d.length=e;d.pa=r;0==e&&(delete R[a][b][c],R[a][b].j--,0==R[a][b].j&&(delete R[a][b],R[a].j--),0==R[a].j&&delete R[a])}}function Wb(a,b,c,d,f){var e=1,b=A(b);if(a[b]){a.o--;a=a[b];a.D?a.D++:a.D=1;try{for(var g=a.length,h=0;h<g;h++){var i=a[h];i&&!i.s&&(e&=Xb(i,f)!==r)}}finally{a.D--,Vb(c,d,b,a)}}return Boolean(e)}function Xb(a,b){a.ia&&V(a.key);return a.handleEvent(b)}
function Tb(a,b){if(!Q[a])return l;var c=Q[a],d=c.type,f=R;if(!(d in f))return l;var f=f[d],e,g;if(!Lb){var h;if(!(h=b))a:{h=["window","event"];for(var i=v;e=h.shift();)if(i[e]!=m)i=i[e];else{h=m;break a}h=i}e=h;h=l in f;i=r in f;if(h){if(0>e.keyCode||e.returnValue!=k)return l;a:{var n=r;if(0==e.keyCode)try{e.keyCode=-1;break a}catch(p){n=l}if(n||e.returnValue==k)e.returnValue=l}}n=new Qb;n.init(e,this);e=l;try{if(h){for(var j=[],q=n.currentTarget;q;q=q.parentNode)j.push(q);g=f[l];g.o=g.j;for(var x=
j.length-1;!n.W&&0<=x&&g.o;x--)n.currentTarget=j[x],e&=Wb(g,j[x],d,l,n);if(i){g=f[r];g.o=g.j;for(x=0;!n.W&&x<j.length&&g.o;x++)n.currentTarget=j[x],e&=Wb(g,j[x],d,r,n)}}else e=Xb(c,n)}finally{j&&(j.length=0)}return e}d=new Qb(b,this);return e=Xb(c,d)};function Yb(a,b){var c=eb().createElement("DIV");c.innerHTML=a(b||Zb,k,k);if(1==c.childNodes.length){var d=c.firstChild;if(1==d.nodeType)return d}return c}var Zb={};function $b(a,b,c){w(b)?ac(a,c,b):bb(b,ga(ac,a))}function ac(a,b,c){a.style[String(c).replace(/\-([a-z])/g,function(a,b){return b.toUpperCase()})]=b}function bc(a,b,c){var d,f=G&&(Fa||Ma)&&I("1.9");r?(d=b.x,b=b.y):(d=b,b=c);a.style.left=cc(d,f);a.style.top=cc(b,f)}function cc(a,b){"number"==typeof a&&(a=(b?Math.round(a):a)+"px");return a}function dc(a,b){var c=a.style;"opacity"in c?c.opacity=b:"MozOpacity"in c?c.MozOpacity=b:"filter"in c&&(c.filter=""===b?"":"alpha(opacity="+100*b+")")}
function ec(a,b){a.style.display=b?"":"none"};/*
 Portions of this code are from the google-caja project, received by
 Google under the Apache license (http://code.google.com/p/google-caja/).
 All other code is Copyright 2009 Google, Inc. All Rights Reserved.

// Copyright (C) 2006 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

*/
/*
 Portions of this code are from the google-caja project, received by
 Google under the Apache license (http://code.google.com/p/google-caja/).
 All other code is Copyright 2009 Google, Inc. All Rights Reserved.

// Copyright (C) 2006 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

*/
function fc(){Nb.call(this)}ha(fc,Nb);fc.prototype.ja=l;fc.prototype.addEventListener=function(a,b,c,d){U(this,a,b,c,d)};fc.prototype.removeEventListener=function(a,b,c,d){Ub(this,a,b,c,d)};F||H&&I("525");function gc(){}ba(gc);gc.S();function W(a){Nb.call(this);this.Oa=a||eb();this.Ia=hc}ha(W,fc);var hc=m;W.prototype.Ca=m;W.prototype.Ia=m;W.prototype.ka=function(){return this.Ca};function ic(){}ba(ic);var jc={};function X(a,b,c){W.call(this,c);if(!b){for(var b=this.constructor,d;b;){d=A(b);if(d=jc[d])break;b=b.X?b.X.constructor:m}b=d?y(d.S)?d.S():new d:m}this.Qa=b;this.Ba=a}ha(X,W);X.prototype.Ba=m;if(!y(X))throw Error("Invalid component class "+X);if(!y(ic))throw Error("Invalid renderer class "+ic);var kc=A(X);jc[kc]=ic;function lc(){return new X(m)}if(!y(lc))throw Error("Invalid decorator function "+lc);F&&I(8);function mc(a){return"object"===typeof a&&a&&0===a.Ma?a.content:String(a).replace(nc,oc)}var pc={"\x00":"&#0;",'"':"&quot;","&":"&amp;","'":"&#39;","<":"&lt;",">":"&gt;","\t":"&#9;","\n":"&#10;","\x0B":"&#11;","\f":"&#12;","\r":"&#13;"," ":"&#32;","-":"&#45;","/":"&#47;","=":"&#61;","`":"&#96;","\u0085":"&#133;","\u00a0":"&#160;","\u2028":"&#8232;","\u2029":"&#8233;"};function oc(a){return pc[a]}var nc=/[\x00\x22\x26\x27\x3c\x3e]/g;function qc(a,b,c){var d=this;c||(c="Click and Drag to Annotate");this.element=Yb(rc,{Ea:c});this.a=a;this.da=Kb(".annotorious-hint-msg",this.element)[0];this.ba=Kb(".annotorious-hint-icon",this.element)[0];this.ha=function(){d.show()};this.ga=function(){sc(d)};this.H();sc(this);b.appendChild(this.element)}
qc.prototype.H=function(){var a=this;this.za=U(this.ba,"mouseover",function(){a.show();window.clearTimeout(a.M)});this.ya=U(this.ba,"mouseout",function(){sc(a)});Y(this.a,tc,this.ha);Y(this.a,uc,this.ga)};qc.prototype.K=function(){V(this.za);V(this.ya);var a=this.a.p[tc];a&&za(a,this.ha);(a=this.a.p[uc])&&za(a,this.ga)};qc.prototype.show=function(){window.clearTimeout(this.M);dc(this.da,0.8);var a=this;this.M=window.setTimeout(function(){sc(a)},3E3)};
function sc(a){window.clearTimeout(a.M);dc(a.da,0)};function vc(a,b){this.h=a;this.a=b;this.z=[];this.l=[];this.e=this.h.getContext("2d");this.m=l;this.A=r;var c=this;U(this.h,wc,function(a){if(c.m){var b=xc(c,a.offsetX,a.offsetY);b?(c.A=c.A&&b==c.c,c.c?c.c!=b&&(c.m=r,c.a.popup.startHideTimer()):(c.c=b,zc(c),c.a.fireEvent(Ac,{annotation:c.c,mouseEvent:a}))):!c.A&&c.c&&(c.m=r,c.a.popup.startHideTimer())}else c.t=a});Y(b,uc,function(){delete c.c;c.m=l});Y(b,Bc,function(){if(!c.m&&c.t){var a=c.c;c.c=xc(c,c.t.offsetX,c.t.offsetY);c.m=l;a!=c.c?(zc(c),c.a.fireEvent(Cc,
{annotation:a,mouseEvent:c.t}),c.a.fireEvent(Ac,{annotation:c.c,mouseEvent:c.t})):c.c&&c.a.popup.clearHideTimer()}else zc(c)})}function Dc(a,b){a.z.push(b);var c=b.shapes[0];if("pixel"!=c.units)if("rect"==c.type)var d=c.geometry,c=a.a.R({x:d.x,y:d.y}),d=a.a.R({x:d.x+d.width,y:d.y+d.height}),c=new na("rect",new ma(c.x,c.y,d.x-c.x,d.y-c.y));else if("polygon"==c.type){var f=[];D(c.geometry.points,function(b){f.push(a.a.R(b))});c=new na("polygon",new ja(f))}else c=k;a.l[B(b.shapes[0])]=c;zc(a)}
vc.prototype.v=function(a){(this.c=a)?this.A=l:this.a.popup.startHideTimer();zc(this);this.m=l};function xc(a,b,c){a=a.C(b,c);if(0<a.length)return a[0]}
vc.prototype.C=function(a,b){var c=[],d=this;D(this.z,function(f){var e;e=d.l[B(f.shapes[0])];if("rect"==e.type)e=a<e.geometry.x||b<e.geometry.y||a>e.geometry.x+e.geometry.width||b>e.geometry.y+e.geometry.height?r:l;else if("polygon"==e.type){e=e.geometry.points;for(var g=r,h=e.length-1,i=0;i<e.length;i++)e[i].y>b!=e[h].y>b&&a<(e[h].x-e[i].x)*(b-e[i].y)/(e[h].y-e[i].y)+e[i].x&&(g=!g),h=i;e=g}else e=r;e&&c.push(f)});C.sort.call(c,function(a,b){var c=d.l[B(a.shapes[0])],h=d.l[B(b.shapes[0])];return oa(c)-
oa(h)}||Ba);return c};function Ec(a,b,c){var d;d=a.a.Da();var f;a:{f=function(a){return a.getSupportedShapeType()==b.type};for(var e=d.length,g=w(d)?d.split(""):d,h=0;h<e;h++)if(h in g&&f.call(k,g[h])){f=h;break a}f=-1}(d=0>f?m:w(d)?d.charAt(f):d[f])?d.drawShape(a.e,b,c):console.log("WARNING unsupported shape type: "+b.type)}
function zc(a){a.e.clearRect(0,0,a.h.width,a.h.height);D(a.z,function(b){b!=a.c&&Ec(a,a.l[B(b.shapes[0])])});if(a.c){var b=a.l[B(a.c.shapes[0])];Ec(a,b,l);if("rect"!=b.type)if("polygon"==b.type){for(var b=b.geometry.points,c=b[0].x,d=b[0].x,f=b[0].y,e=b[0].y,g=1;g<b.length;g++)b[g].x>d&&(d=b[g].x),b[g].x<c&&(c=b[g].x),b[g].y>e&&(e=b[g].y),b[g].y<f&&(f=b[g].y);b=new na("rect",new ma(c,f,d-c,e-f))}else b=k;b=b.geometry;a.a.popup.show(a.c,new ia(b.x,b.y+b.height+5))}};var Z="ontouchstart"in window,wc=Z?"touchmove":"mousemove",Fc=Z?"touchend":"mouseup",Gc={sa:Z?"touchstart":"mousedown",Z:Z?"touchenter":"mouseover",Ka:wc,La:Fc,Y:Z?"touchleave":"mouseout",Ja:Z?"touchend":"click"};function Hc(a,b){var c=r;return c=!a.offsetX||!a.offsetY&&a.k.changedTouches?{x:a.k.changedTouches[0].clientX-Ic(b).left,y:a.k.changedTouches[0].clientY-Ic(b).top}:{x:a.offsetX,y:a.offsetY}};function Jc(){}u=Jc.prototype;u.init=function(a,b){this.$="#000000";this.aa="#ffffff";this.ta=k;this.va="#fff000";this.ua=k;this.h=b;this.a=a;this.e=b.getContext("2d");this.e.lineWidth=1;this.L=r};
u.H=function(){var a=this,b=this.h;this.N=U(this.h,wc,function(c){c=Hc(c,b);if(a.L){a.f={x:c.x,y:c.y};a.e.clearRect(0,0,b.width,b.height);var c=a.f.x-a.b.x,d=a.f.y-a.b.y;a.e.strokeStyle=a.$;a.e.strokeRect(a.b.x+0.5,a.b.y+0.5,c,d);a.e.strokeStyle=a.aa;0<c&&0<d?a.e.strokeRect(a.b.x+1.5,a.b.y+1.5,c-2,d-2):0<c&&0>d?a.e.strokeRect(a.b.x+1.5,a.b.y-0.5,c-2,d+2):0>c&&0>d?a.e.strokeRect(a.b.x-0.5,a.b.y-0.5,c+2,d+2):a.e.strokeRect(a.b.x-0.5,a.b.y+1.5,c+2,d-2)}});this.O=U(b,Fc,function(c){var d=Hc(c,b),f=a.getShape(),
c=c.k?c.k:c;a.L=r;f?(a.K(),a.a.fireEvent(Kc,{mouseEvent:c,shape:f,viewportBounds:a.getViewportBounds()})):(a.a.fireEvent(Lc),c=a.a.C(d.x,d.y),0<c.length&&a.a.v(c[0]))})};u.K=function(){this.N&&(V(this.N),delete this.N);this.O&&(V(this.O),delete this.O)};u.getSupportedShapeType=function(){return"rect"};u.startSelection=function(a,b){var c={x:a,y:b};this.L=l;this.H(c);this.b=new ia(a,b);this.a.fireEvent(Mc,{offsetX:a,offsetY:b});$b(document.body,"-webkit-user-select","none")};
u.stopSelection=function(){this.K();this.e.clearRect(0,0,this.h.width,this.h.height);$b(document.body,"-webkit-user-select","auto");delete this.f};u.getShape=function(){if(this.f&&3<Math.abs(this.f.x-this.b.x)&&3<Math.abs(this.f.y-this.b.y)){var a=this.getViewportBounds(),b=this.a.ra({x:a.left,y:a.top}),a=this.a.ra({x:a.right-1,y:a.bottom-1});return new na("rect",new ma(b.x,b.y,a.x-b.x,a.y-b.y))}};
u.getViewportBounds=function(){var a,b;this.f.x>this.b.x?(a=this.f.x,b=this.b.x):(a=this.b.x,b=this.f.x);var c,d;this.f.y>this.b.y?(c=this.b.y,d=this.f.y):(c=this.f.y,d=this.b.y);return{top:c,right:a,bottom:d,left:b}};
u.drawShape=function(a,b,c){var d;"rect"==b.type&&(c?(a.lineWidth=1.2,c=this.va,d=this.ua):(a.lineWidth=1,c=this.aa,d=this.ta),b=b.geometry,a.strokeStyle=this.$,a.strokeRect(b.x+0.5,b.y+0.5,b.width+1,b.height+1),a.strokeStyle=c,a.strokeRect(b.x+1.5,b.y+1.5,b.width-1,b.height-1),d&&(a.fillStyle=d,a.fillRect(b.x+1.5,b.y+1.5,b.width-1,b.height-1)))};function Nc(a){return'<canvas class="annotorious-item annotorious-opacity-fade" style="position:absolute; top:0px; left:0px; width:'+mc(a.width)+"px; height:"+mc(a.height)+'px; z-index:0" width="'+mc(a.width)+'" height="'+mc(a.height)+'"></canvas>'}
function rc(a){return'<div class="annotorious-hint" style="white-space:nowrap; position:absolute; top:0px; left:0px; pointer-events:none;"><div class="annotorious-hint-msg annotorious-opacity-fade">'+mc(a.Ea)+'</div><div class="annotorious-hint-icon" style="pointer-events:auto"></div></div>'};function Oc(a,b){function c(c){var d=r,f=c.relatedTarget||r;f||(d=l);ib(e,f)&&(d=l);var g;if(g=ib(b.editor.element[0],f))g=b.editor.annotation,g=!g?r:g.src==a.src;g&&(d=l);ib(b.viewer.element[0],f)&&Pc(n)&&(d=l);c.k&&c.k.touches&&(d=r);return d}var d=Ic(b.element[0].firstChild),f=new Qc,e=hb("div","yuma-annotationlayer");$b(e,"position","relative");var g=a.width,h=a.height;if(h==k)throw Error("missing height argument");e.style.width=cc(g,l);e.style.height=cc(h,l);(g=a.parentNode)&&g.replaceChild(e,
a);e.appendChild(a);var i=Yb(Nc,{width:a.width,height:a.height});e.appendChild(i);var n=new Rc(a,b,f,d),p=Yb(Nc,{width:a.width,height:a.height});Z||ec(p,r);e.appendChild(p);var j=new vc(i,f),q=new Jc;q.init(f,p);new qc(f,e);f.ra=function(a){return a};f.R=function(a){return a};f.Da=function(){return[q]};f.v=function(a){j.v(a)};f.popup=n;f.C=function(a,b){return j.C(a,b)};U(e,Gc.Z,function(a){c(a)||f.fireEvent(tc)});U(e,Gc.Y,function(a){c(a)||f.fireEvent(uc)});n.fa.push(function(a){c(a)||f.fireEvent(tc)});
n.ea.push(function(a){c(a)||f.fireEvent(uc)});U(Z?p:i,Gc.sa,function(a){var b=Hc(a,i);a.preventDefault();ec(p,l);j.v(k);q.startSelection(b.x,b.y)});Y(f,tc,function(){b.clearViewerHideTimer();dc(i,1)});Y(f,uc,function(){dc(i,0.4)});Y(f,Kc,function(c){var e={src:a.src,shapes:[c.shape]};b.publish("beforeAnnotationCreated",e);var f=Ic(a),g=c.shape.geometry,c=g.x+f.left-d.left+window.pageXOffset+16,f=g.y+g.height+f.top+window.pageYOffset-d.top+5;b.showEditor(e,{top:window.pageYOffset-d.top,left:0});bc(b.editor.element[0],
c,f)});Y(f,Lc,function(){Z||ec(p,r);q.stopSelection()});b.viewer.on("edit",function(c){if(c.url==a.src){ec(p,l);j.v(k);var e=Ic(a),f=c.shapes[0].geometry,c=f.x+e.left-d.left+16,e=f.y+f.height+e.top-d.top+window.pageYOffset+5;bc(b.editor.element[0],0,window.pageYOffset-d.top);b.editor.show();bc(b.editor.element[0],c,e)}});b.subscribe("annotationCreated",function(b){if(b.src==a.src&&(q.stopSelection(),b.src==a.src)){var c={},d;for(d in b)c[d]=b[d];Dc(j,c)}});b.subscribe("annotationsLoaded",function(b){D(b,
function(b){console.log(b);console.log(a);console.log(b.src==a.src);b.src==a.src&&Dc(j,b)})});b.subscribe("annotationDeleted",function(b){b.src==a.src&&(b==j.c&&delete j.c,za(j.z,b),delete j.l[B(b.shapes[0])],zc(j));f.fireEvent(Bc)});b.subscribe("annotationEditorHidden",function(){Z||ec(p,r);q.stopSelection();f.fireEvent(Bc)})}var Sc=window.Annotator.Plugin;function Tc(a){this.wa=a}Tc.prototype.pluginInit=function(){var a=this;D(this.wa.getElementsByTagName("img"),function(b){new Oc(b,a.annotator)})};
Sc.AnnotoriousImagePlugin=Tc;function Rc(a,b,c,d){this.ca=a;this.g=b;this.xa=c;this.I=d;this.J=r;this.fa=[];this.ea=[];var f=this;U(this.g.viewer.element[0],Gc.Z,function(a){Pc(f)&&(f.clearHideTimer(),D(f.fa,function(b){b(a)}))});U(this.g.viewer.element[0],Gc.Y,function(a){Pc(f)&&(b.clearViewerHideTimer(),f.startHideTimer(),D(f.ea,function(b){b(a)}))})}function Pc(a){var b=a.g.viewer.annotations;return!b||1>b.length?r:b[0].src==a.ca.src}
Rc.prototype.startHideTimer=function(){var a=Za(this.g.viewer.element[0]);if(!(0<=xa(a,"annotator-hide"))&&(this.J=r,!this.u)){var b=this;this.u=window.setTimeout(function(){b.xa.fireEvent(Bc);!b.J&&Pc(b)&&($a(b.g.viewer.element[0],"annotator-hide"),b.g.viewer.annotations=[],delete b.u)},300)}};Rc.prototype.clearHideTimer=function(){this.J=l;this.u&&(window.clearTimeout(this.u),delete this.u)};
Rc.prototype.show=function(a,b){ab(this.g.viewer.element[0],"annotator-hide");var c=Ic(this.ca);bc(this.g.viewer.element[0],0,window.pageYOffset-this.I.top);this.g.viewer.load([a]);bc(this.g.viewer.element[0],c.left-this.I.left+b.x+16,c.top+window.pageYOffset-this.I.top+b.y);this.clearHideTimer()};F||G&&I("1.9.3");function Ic(a){for(var b=0,c=0;a&&!isNaN(a.offsetLeft)&&!isNaN(a.offsetTop);)b+=a.offsetLeft-a.scrollLeft,c+=a.offsetTop-a.scrollTop,a=a.offsetParent;return{top:c,left:b}};function Qc(){this.p=[]}function Y(a,b,c){a.p[b]||(a.p[b]=[]);a.p[b].push(c)}Qc.prototype.fireEvent=function(a,b){var c=r,d=this.p[a];d&&D(d,function(a){a=a(b);a!==k&&!a&&(c=l)});return c};var tc="onMouseOverItem",uc="onMouseOutOfItem",Ac="onMouseOverAnnotation",Cc="onMouseOutOfAnnotation",Mc="onSelectionStarted",Lc="onSelectionCanceled",Kc="onSelectionCompleted",Bc="beforePopupHide";
