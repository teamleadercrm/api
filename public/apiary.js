var embed = new Apiary.Embed({
  subdomain: 'teamleadercrm',
  preferences: {
    header: '.header',
    defaultHost: 'production',
    collapseMachineColumnByDefault: true,
    permalinks: true,
    console: false
  },
  customFonts: {
    families: [
      {
        name: 'Proxima Nova',
        style: 'normal',
        weight: 200,
        formats: [
          {
            format: 'woff',
            url:
'https://focus.teamleader.eu/images/fonts/proximanova-reg-webfont.woff'
          }
        ]
      }
    ]
  },
  theme: {
    fontFamily: 'Proxima Nova',
    tableOfContents: {
      backgroundColor: '#fdfdfd',
      borderRight: '1px solid #e9e9e9',
      fontSize: '16px',
      section: {
        title: {
          color: '#00ACA9'
        }
      }
    },
    humanColumn: {
      content: {
        apiName: {
          display: 'none',
        },
        section: {
          title: {
            color: '#3b4151',
            fontSize: '35px'
          },
          apiDescription: {
            h3: {
              marginTop: '20px'
            },
            code: {
              color: '#00ACA9'
            },
            pre: {
              padding: '15px',
              backgroundColor: '#fafafc',
              borderRadius: '5px'
            },
            ul: {
              li: {
                marginBottom: '5px'
              }
            }
          }
        }
      }
    }
  }
});

const msg = embed.onReady(function (iframeElement, event) {
  if (typeof console._commandLineAPI !== 'undefined') {
    console._commandLineAPI.clear();
  } else if (typeof console._inspectorCommandLineAPI !== 'undefined') {
    console._inspectorCommandLineAPI.clear();
  } else if (typeof console.clear !== 'undefined') {
    console.clear();
  }

  console.log('Hello fellow developer!');
  console.log('Thank you for showing interest in our source code. Perhaps you\'d like to join our team?');
  console.log('To learn more, visit: https://www.teamleader.eu/company/engineering');
});
