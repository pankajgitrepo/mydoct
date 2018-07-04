<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Kaltura_PlayHomePageVideos.ascx.cs" Inherits="mojoPortal.Web.Century21_Kaltura.Kaltura_PlayHomePageVideos" %>

<portal:OuterWrapperPanel ID="pnlOuterWrap" runat="server">
    <mp:CornerRounderTop ID="ctop1" runat="server" EnableViewState="false" />
    <portal:InnerWrapperPanel ID="pnlInnerWrap" runat="server" CssClass="panelwrapper linksmodule">
      <%--  <portal:ModuleTitleControl ID="Title1" runat="server" EnableViewState="false" />--%>
        <portal:OuterBodyPanel ID="pnlOuterBody" runat="server">
            <portal:InnerBodyPanel ID="pnlInnerBody" runat="server" CssClass="modulecontent">
                <div>
                    <table class="fullWidth">
                        <tr>
                            <td>
                                <div class="fullWidth">
                                    <div class="mediaDescriptionClass" style="height: 400px;">
                                        <div class="mediaContent">
                                            <div id="mediaDescription" class="divMediaDescHomePage"></div>
                                        </div>
                                    </div>
                                    <div id="divKaltura_play_Video" style="width: 75%; height: 400px; float: left;">
                                        <script id="mediaScript"></script>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80%" id="tdVideoTitle"></td>
                        </tr>
                    </table>
                </div>
            </portal:InnerBodyPanel>
        </portal:OuterBodyPanel>
    </portal:InnerWrapperPanel>
    <mp:CornerRounderBottom ID="cbottom1" runat="server" EnableViewState="false" />
    <script type="text/javascript">
        //Get querystring parameter
        function getQueryStringParameter(param) {
            var url = document.URL;
            var index = url.indexOf("?");
            if (index != -1) {
                var params = document.URL.split("?")[1].split("&");
                for (var i = 0; i < params.length; i++) {
                    var singleParam = params[i].split("=");
                    if (singleParam[0] == param) {
                        return singleParam[1];
                    }
                }
            }
            else {
                return null;
            }
        }

        var onKalturaSessionEndSuccess = function (success, results) {
            if (!success)
                alert(results);
        };

        var onGetKalturaSessionSuccess = function (success, results) {
            if (!success)
                alert(results);

            if (results.code && results.message) {
                alert(results.message);
                return;
            }
            handleSession(results);
        };

        var onGetMediaInfoSuccess = function (success, results) {
            if (!success)
                alert(results);

            if (results.code && results.message) {
                alert(results.message);
                return;
            }
            handleMediaInfo(results);
        };

        var kalturaPlayer = null;
        var serviceUrl = null;
        var secret = null;
        var userId = null;
        var partnerId = null;
        var expiry = null;
        var mediaPlayerId = null;
        var flag = null;
        var element = null;
        var mediaId = null;
        var mediaDescriptn = null;
        var client = null;

        //Read and initialize kaltura settings from web.config
        function initialize_PlayVideos() {
            kalturaPlayer = '<%=ConfigurationManager.AppSettings["kalturaPlayer"].ToString() %>';
            serviceUrl = '<%=ConfigurationManager.AppSettings["KalturaServiceUrl"].ToString() %>';
            secret = '<%=ConfigurationManager.AppSettings["KalturaAdminSecret"].ToString() %>';
            userId = '<%=ConfigurationManager.AppSettings["KalturaUserID"].ToString() %>';
            partnerId = '<%=ConfigurationManager.AppSettings["KalturaPartnerID"].ToString() %>';
            expiry = '<%=ConfigurationManager.AppSettings["KalturaSessionExpiry"].ToString() %>';
            var type = KalturaSessionType.USER;
            mediaPlayerId = '<%=ConfigurationManager.AppSettings["KalturaMediaPlayerID"].ToString() %>';
                flag = 0;
                mediaId = getQueryStringParameter('mediaId');
                mediaDescriptn = '<%= Resources.Resource.KalturaMediaDescription %>';

            //Get kaltura session
            var config = new KalturaConfiguration(parseInt(partnerId));
            config.serviceUrl = '<%=ConfigurationManager.AppSettings["KalturaConfigServiceURL"].ToString() %>';
            client = new KalturaClient(config);
            var privileges = null;
            if (mediaId != null) {
                var kSessionStart = client.session.start(onGetKalturaSessionSuccess, secret, userId, type, parseInt(partnerId), parseInt(expiry), privileges);
            }
        }

        function handleSession(results) {
            client.setKs(results);
            var media = client.media.get(onGetMediaInfoSuccess, mediaId, null);
        }

        function handleMediaInfo(result) {
            var src = serviceUrl + "/p/" + partnerId + "/sp/" + partnerId + "00/embedIframeJs/uiconf_id/" + mediaPlayerId + "/partner_id/" + partnerId + "?autoembed=true&entry_id=" + result.id + "&playerId=divKaltura_play_Video&cache_st=" + kalturaPlayer + "&width=740&height=330";
            element = document.getElementById("mediaScript");
            element.src = src;
            var mediaDesc = document.getElementById('mediaDescription');
            if (result.description != undefined) {
                mediaDesc.innerHTML = "<label>" + result.description + "</label>";
            }
            else {
                mediaDesc.innerHTML = "<label>" + mediaDescriptn + "</label>";
            }
            var mediaName = document.getElementById('tdVideoTitle');
            mediaName.innerHTML = "<h3>" + result.name + "</h3>";
        }

        $(document).ready(function () {
            initialize_PlayVideos();
        });

        window.onload = setTimeout(function () {
            var kSessionEnd = client.session.end(onKalturaSessionEndSuccess);
        }, 25000);
    </script>
</portal:OuterWrapperPanel>

<script type="text/javascript">
    $(function () {
        $("#toolbar").remove();
        $(".art-hmenu").removeAttr("style").attr('style', 'display:none');
        $(".art-footer").removeAttr("style").attr('style', 'display:none');
        $(".art-footer-wrapper").removeAttr("style").attr('style', 'display:none');
        $(".searchpanel").removeAttr("style").attr('style', 'display:none');
        $(".topnavwrap").removeAttr("style").attr('style', 'display:none');
        $("#toolbarbut").remove();
        $(".pagebody").addClass("bgColorBody");
        $("#top-stuff").remove();
        var header = $(".art-header");
        header.removeClass("art-header");
        var span = $(".modulelinks");
        span.remove();
        var span1 = $(".showbar");
        span1.remove();
    });
</script>
