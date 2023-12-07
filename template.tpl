___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Channelsight Sales Tracking",
  "categories": ["AFFILIATE_MARKETING", "MARKETING"],
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "Tracks a click from a WTB widget and captures the sale",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const log = require ("logToConsole");
const encodeUriComponent = require('encodeUriComponent');
const encodeUri = require('encodeUri');
const getQueryParameters = require("getQueryParameters");
const setCookie = require('setCookie');
const getCookie = require('getCookieValues');
const getReferrerUrl = require('getReferrerUrl');
const getUrl = require('getUrl');
const copyFromDataLayer = require('copyFromDataLayer');
const sendPixel = require('sendPixel');
const JSON = require('JSON');

var URL = '';
var ORDER_COOKIE_LIFE = 30; // in days
var ORDER_COOKIE = 'channelsight_transaction';
 
var csDataLayerType = copyFromDataLayer('channelsight.type');

var csTest = copyFromDataLayer('channelsight.isTest');

switch(csDataLayerType)
{
  case "urlTracking":
    var csTrackId = getQueryParameters("cstrackid", false);
    
    if (csTrackId != null && csTrackId != "")
    {
      const options = {
                         domain: 'auto',
                        'max-age': 63072000,
                        'path': '/',
                         secure: true
                      };
      setCookie(ORDER_COOKIE, csTrackId, options);
    }

    var csTrackIdUrlRegisterCookie = getCookie(ORDER_COOKIE); 

    var referrer = getReferrerUrl('queryParams');
    var pageUrl = getUrl('quary', false, null, 'gclid');
    
    var urlRegisterAddress = URL + "UrlRegister?id=" + csTrackIdUrlRegisterCookie + "&url=" + encodeUriComponent(pageUrl) +                                          "&referrer=" + encodeUriComponent(referrer);
    
    if (csTest != null && csTest.length > 0)
       urlRegisterAddress += "&test=" + csTest;
    
    urlRegisterAddress += "&isFromGtmTemplate=true";
    
    const onSuccess = () => { 
      log('[CS GTM] URL_REGISTER: success');
      data.gtmOnSuccess();
    };

    const onFailure = () => {
      log('[CS GTM] URL_REGISTER: failed');
      data.gtmOnFailure();
    };
    
    sendPixel(urlRegisterAddress, onSuccess, onFailure);
    
    break;
    
  case "orderTracking":
    var csTrackIdOrderRegisterCookie = getCookie(ORDER_COOKIE);
        
    var csOrder = copyFromDataLayer('channelsight.csOrder');
    
    var csProducts = copyFromDataLayer('channelsight.csProducts');

    var orderRegisterAddress = URL + "OrderRegister?id=" + csTrackIdOrderRegisterCookie + "&data=";     
      
    var csOrderTrackingData = {};

    if (csTest != null && csTest.length > 0)
       csOrderTrackingData.IsTest = csTest;
      
    if (csOrder != null && csOrder.length != 0)
    {
      csOrderTrackingData.order = {};
      csOrderTrackingData.order.Currency = csOrder.Currency;
      csOrderTrackingData.order.TransactionID = csTrackIdOrderRegisterCookie[0];
      
      if(csOrder.OrderTotal != null && csOrder.OrderTotal.length != 0)
        csOrderTrackingData.order.OrderTotal = csOrder.OrderTotal;
        
      if(csOrder.ShipCost != null && csOrder.ShipCost.length != 0)
        csOrderTrackingData.order.ShipCost = csOrder.ShipCost;
        
      if(csOrder.Tax != null && csOrder.Tax.length != 0)
        csOrderTrackingData.order.Tax = csOrder.Tax;
    }

    if(csProducts != null && csProducts.length != 0)
    {
      csOrderTrackingData.products = [];
      
      for(var i = 0; i < csProducts.length; i++)
      {
        var product = {};
        product.Name = csProducts[i].Name;
        product.ProductCode = csProducts[i].ProductCode;
        product.Category = csProducts[i].Category;
        product.Price = csProducts[i].Price;
        product.Quantity = csProducts[i].Quantity;
        product.TransactionID = csTrackIdOrderRegisterCookie[0];
        csOrderTrackingData.products.push(product);
      }         
    }
    
    orderRegisterAddress += encodeUriComponent(JSON.stringify(csOrderTrackingData));
    
     if (csTest != null && csTest.length > 0)
       orderRegisterAddress += "&test=" + csTest;
    
    orderRegisterAddress += "&isFromGtmTemplate=true"; 
    
    const onSuccessOrder = () => { 
          log('[CS GTM] ORDER_REGISTER: success');
          data.gtmOnSuccess();
      };
      
    const onFailureOrder = () => {
          log('[CS GTM] ORDER_REGISTER: failed');
          data.gtmOnFailure();
      };
    
    sendPixel(orderRegisterAddress, onSuccessOrder, onFailureOrder);
    break;
}

data.gtmOnSuccess();


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "set_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedCookies",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "name"
                  },
                  {
                    "type": 1,
                    "string": "domain"
                  },
                  {
                    "type": 1,
                    "string": "path"
                  },
                  {
                    "type": 1,
                    "string": "secure"
                  },
                  {
                    "type": 1,
                    "string": "session"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "channelsight_transaction"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "cookieAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "cookieNames",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "channelsight_transaction"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_url",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urlParts",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "queriesAllowed",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_referrer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urlParts",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "queriesAllowed",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_data_layer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedKeys",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "send_pixel",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 3/27/2020, 10:30:13 AM


