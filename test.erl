-module(test).
-include_lib("xmerl/include/xmerl.hrl").
-include_lib("public_key/include/public_key.hrl").
% -include("esaml.hrl").
-export([test/0]).

-define(xpath_generic(XPath, Record, Field, TransFun, TargetType, NotFoundRet),
	fun(Resp) ->
        case xmerl_xpath:string(XPath, Xml, [{namespace, Ns}]) of
            [#TargetType{value = V}] -> Resp#Record{Field = TransFun(V)};
            _ -> NotFoundRet
        end
    end).

-define(xpath_generic(XPath, Record, Field, TargetType, NotFoundRet),
	fun(Resp) ->
        case xmerl_xpath:string(XPath, Xml, [{namespace, Ns}]) of
            [#TargetType{value = V}] -> Resp#Record{Field = V};
            _ -> NotFoundRet
        end
    end).

-define(xpath_attr(XPath, Record, Field),
    ?xpath_generic(XPath, Record, Field, xmlAttribute, Resp)).
-define(xpath_attr(XPath, Record, Field, TransFun),
    ?xpath_generic(XPath, Record, Field, TransFun, xmlAttribute, Resp)).

-define(xpath_attr_required(XPath, Record, Field, Error),
    ?xpath_generic(XPath, Record, Field, xmlAttribute, {error, Error})).
-define(xpath_attr_required(XPath, Record, Field, TransFun, Error),
    ?xpath_generic(XPath, Record, Field, TransFun, xmlAttribute, {error, Error})).

-define(xpath_text(XPath, Record, Field),
    ?xpath_generic(XPath, Record, Field, xmlText, Resp)).
-define(xpath_text(XPath, Record, Field, TransFun),
    ?xpath_generic(XPath, Record, Field, TransFun, xmlText, Resp)).

-define(xpath_recurse(XPath, Record, Field, F),
    fun(Resp) ->
        case xmerl_xpath:string(XPath, Xml, [{namespace, Ns}]) of
            [E = #xmlElement{}] ->
                case F(E) of
                    {error, V} -> {error, V};
                    {ok, V} -> Resp#Record{Field = V}
                end;
            _ -> Resp
        end
    end).

threaduntil([F | Rest], Acc) ->
    case (catch F(Acc)) of
        {'EXIT', Reason} ->
            {error, Reason};
        {error, Reason} ->
            {error, Reason};
        {stop, LastAcc} ->
            {ok, LastAcc};
        NextAcc ->
            threaduntil(Rest, NextAcc)
    end.

decode_idp_metadata(Xml) ->
    Ns = [{"samlp", 'urn:oasis:names:tc:SAML:2.0:protocol'},
          {"saml", 'urn:oasis:names:tc:SAML:2.0:assertion'},
          {"md", 'urn:oasis:names:tc:SAML:2.0:metadata'},
          {"ds", 'http://www.w3.org/2000/09/xmldsig#'}],
    threaduntil([
        ?xpath_attr_required("/md:EntityDescriptor/@entityID", esaml_idp_metadata, entity_id, bad_entity),
        ?xpath_attr_required("/md:EntityDescriptor/md:IDPSSODescriptor/md:SingleSignOnService[@Binding='urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST']/@Location",
            esaml_idp_metadata, login_location, missing_sso_location),
        ?xpath_attr("/md:EntityDescriptor/md:IDPSSODescriptor/md:SingleLogoutService[@Binding='urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST']/@Location",
            esaml_idp_metadata, logout_location),
        ?xpath_text("/md:EntityDescriptor/md:IDPSSODescriptor/md:NameIDFormat/text()",
            esaml_idp_metadata, name_format, fun nameid_map/1),
        ?xpath_text("/md:EntityDescriptor/md:IDPSSODescriptor/md:KeyDescriptor[@use='signing']/ds:KeyInfo/ds:X509Data/ds:X509Certificate/text()", esaml_idp_metadata, certificate, fun(X) -> base64:decode(list_to_binary(X)) end),
        ?xpath_recurse("/md:EntityDescriptor/md:ContactPerson[@contactType='technical']", esaml_idp_metadata, tech, decode_contact),
        ?xpath_recurse("/md:EntityDescriptor/md:Organization", esaml_idp_metadata, org, decode_org)
    ], #esaml_idp_metadata{}).

test() ->
	Data = "<md:EntitiesDescriptor xmlns=\"urn:oasis:names:tc:SAML:2.0:metadata\" xmlns:md=\"urn:oasis:names:tc:SAML:2.0:metadata\" xmlns:saml=\"urn:oasis:names:tc:SAML:2.0:assertion\" xmlns:ds=\"http://www.w3.org/2000/09/xmldsig#\" Name=\"urn:keycloak\"><md:EntityDescriptor xmlns=\"urn:oasis:names:tc:SAML:2.0:metadata\" xmlns:md=\"urn:oasis:names:tc:SAML:2.0:metadata\" xmlns:saml=\"urn:oasis:names:tc:SAML:2.0:assertion\" xmlns:ds=\"http://www.w3.org/2000/09/xmldsig#\" entityID=\"https://access.thon.org/auth/realms/THON\"><md:IDPSSODescriptor WantAuthnRequestsSigned=\"true\" protocolSupportEnumeration=\"urn:oasis:names:tc:SAML:2.0:protocol\"><md:KeyDescriptor use=\"signing\"><ds:KeyInfo><ds:KeyName>YmbUNjAeWHKYmpvRRWUAOHSVIIqRjXwka1nnfGp7FBw</ds:KeyName><ds:X509Data><ds:X509Certificate>MIIClzCCAX8CBgFvUqgGMzANBgkqhkiG9w0BAQsFADAPMQ0wCwYDVQQDDARUSE9OMB4XDTE5MTIyOTE3MTQwMFoXDTI5MTIyOTE3MTU0MFowDzENMAsGA1UEAwwEVEhPTjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALL5n/dh4DVUddHE2qXQCbPW5zQIVqVUfp4HuBvmkvTD9XCxwzAONDFSMhDp7mwfL9UGcy/C6tqOrGbV7kFnI5UjJydNXEA0raT0YCVH5Jbs7FRpRxjYEmPUjdEzF99j/HRIn0pJACrzNvWOlQIuin4RA7RQtR1x7JYr69lIxaUEuVuKkMG2of5cHHUb8bXvkSQeO4BTQJiTpqv7d4uELg2lFDbA7mDwP5250l6FmXtCpom/DlzzXtqtWz81F+BxFOVZ9LMzdf5ZFDII23O16OY5VZXoYzBeBsIy8+MtCq0r8njAUO+V3ykj+p/BTrzfxhyyMsi7Bo6yMRuOvof7eUUCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAT8rMGkJA7UaHZ6o3CepayrhHJA3vKOH7gLpjRiePZDXz7cc2gXS77Yk8Py0WDyyu6mT1XcPdbDXq9CtiTiCl6o9bnsvSYNu65mhX3aSHbv00USCksDtpuTnvGx6dD7mER8nDpPoyiy4/QH9b0HdRacZ7myvOREDcd9t90q5hABZm8hMP9hNz1A9EpSYnPuLpFYjy4S+/GIXXugIvJvxAxNVe6aijo5pVGfQ/hHEeEol+8i0U4N1l/tVtp0FLsJWYBeLnpvkMt03t12++m2rfOOmZBsaslNXZzTyAV0S1Jk78iHrImF/Fz3mBK2ieHrGTaiyAPnGr4A8IVY450WuRFQ==</ds:X509Certificate></ds:X509Data></ds:KeyInfo></md:KeyDescriptor><md:SingleLogoutService Binding=\"urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST\" Location=\"https://access.thon.org/auth/realms/THON/protocol/saml\"/><md:SingleLogoutService Binding=\"urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect\" Location=\"https://access.thon.org/auth/realms/THON/protocol/saml\"/><md:NameIDFormat>urn:oasis:names:tc:SAML:2.0:nameid-format:persistent</md:NameIDFormat><md:NameIDFormat>urn:oasis:names:tc:SAML:2.0:nameid-format:transient</md:NameIDFormat><md:NameIDFormat>urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified</md:NameIDFormat><md:NameIDFormat>urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress</md:NameIDFormat><md:SingleSignOnService Binding=\"urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST\" Location=\"https://access.thon.org/auth/realms/THON/protocol/saml\"/><md:SingleSignOnService Binding=\"urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect\" Location=\"https://access.thon.org/auth/realms/THON/protocol/saml\"/><md:SingleSignOnService Binding=\"urn:oasis:names:tc:SAML:2.0:bindings:SOAP\" Location=\"https://access.thon.org/auth/realms/THON/protocol/saml\"/></md:IDPSSODescriptor></md:EntityDescriptor></md:EntitiesDescriptor>",
	{Xml, _} = xmerl_scan:string(Data, [{namespace_conformant, true}]),
	Xml.
