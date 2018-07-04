<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Kaltura_PlayVideos.ascx.cs" Inherits="mojoPortal.Web.Century21_Kaltura.Kaltura_PlayVideos1" %>

<portal:OuterWrapperPanel ID="pnlOuterWrap" runat="server">
    <mp:CornerRounderTop ID="ctop1" runat="server" EnableViewState="false" />
    <portal:InnerWrapperPanel ID="pnlInnerWrap" runat="server" CssClass="panelwrapper linksmodule">
       <%-- <portal:ModuleTitleControl ID="Title1" runat="server" EnableViewState="false" />--%>
        <portal:OuterBodyPanel ID="pnlOuterBody" runat="server">
            <portal:InnerBodyPanel ID="pnlInnerBody" runat="server" CssClass="modulecontent">
                <div>
                    <table class="fullWidth">
                        <tr>
                            <td>
                                <div class="fullWidth">
                                    
                                    <div id="divKaltura_play_Video" class="divKalturaVideo">
                                        <script id="mediaScript"></script>
                                    </div>
                                    <div class="mediaDescriptionClass">
                                        <div class="mediaContent">
                                            <div class="spanRelatedVideosStyle" id="spanRelatedVideos"></div><br />
                                            <table class="fullWidth">
                                                <tbody id="kaltura_Related_Media"></tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="tdemptyClass"></td>
                        </tr>
                        <tr>
                            <td>
                                <div class="divLikesAndDescription">
                                    <table class="fullWidth">
                                        <tr>
                                            <td class="tdVideoName" id="tdVideoTitle"></td>
                                            <td class="tdLikeIcon">
                                                <asp:UpdatePanel ID="updPnlLikes" runat="server" UpdateMode="Always">
                                                    <ContentTemplate>
                                                        <div>
                                                            <table>
                                                                <tr>
                                                                    <td class="tdRightAlign">
                                                                        <asp:ImageButton ID="imgBtnLikes" OnClick="imgBtnLikes_Click" runat="server" AlternateText="Like"
                                                                            ImageUrl="~/Data/Sites/1/skins/Theme_C21/images/likeicon_blue.png" />
                                                                            <br />
                                                                            <span class="kalturaLikes"><asp:Label ID="lblLikesCount" runat="server" Text="0 likes"></asp:Label></span>&nbsp;&nbsp;
                                                                    </td>                                                                
                                                                    <td class="tdRightAlign">
                                                                        
                                                                         <asp:ImageButton ID="imgBtnFavourites" OnClick="imgBtnFavourites_Click" width="30px" Height="30px" runat="server" AlternateText="Favourites"
                                                                            ImageUrl="~/Data/Sites/1/skins/Theme_C21/images/fav_icon.png" ToolTip="Add to Favourites"/>&nbsp;&nbsp;
                                                                       <%--  <span class="kalturaLikes"><asp:Label ID="Label1" runat="server" Text="Add to Favourites"></asp:Label></span>&nbsp;&nbsp;--%>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </div>

                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <div id="mediaDescription" class="mediaDesc"></div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                        <td>
                        <div class="mediaDescriptionClassres">
                                        <div class="mediaContent">
                                            <div class="spanRelatedVideosStyle" id="spanRelatedVideos_Res"></div><br />
                                            <table class="fullWidth">
                                                <tbody id="kaltura_Related_Media_Res"></tbody>
                                            </table>
                                        </div>
                                    </div>
                        </td>
                        </tr>
                    </table>
                </div>
            </portal:InnerBodyPanel>
        </portal:OuterBodyPanel>
    </portal:InnerWrapperPanel>
    <mp:CornerRounderBottom ID="cbottom1" runat="server" EnableViewState="false" />
    <script type="text/javascript">
        /*
        (function ($) {
            $(window).load(function () {
                $.mCustomScrollbar.defaults.scrollButtons.enable = true;
                $(".mediaDescriptionClass").mCustomScrollbar({ theme: "dark" });
            });
        })(jQuery);
        */
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

        var onGetRelatedMediaInfoSuccess = function (success, results) {
            if (!success)
                alert(results);

            if (results.code && results.message) {
                alert(results.message);
                return;
            }
            handleRelatedMediaInfo(results);
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
        var categoryName = null;
        var mediaDescriptn = null;
        var playVideoPageURL = null;
        var filterPageSize = null;
        var client = null;

        //Read and initialize kaltura settings from web.config
        function initialize_PlayVideos() {
            kalturaPlayer = '<%=ConfigurationManager.AppSettings["kalturaPlayer"].ToString() %>';
            serviceUrl = '<%=ConfigurationManager.AppSettings["KalturaServiceUrl"].ToString() %>';
            secret = '<%=ConfigurationManager.AppSettings["KalturaAdminSecret"].ToString() %>';
            userId = '<%=ConfigurationManager.AppSettings["KalturaUserID"].ToString() %>';
            partnerId = '<%=ConfigurationManager.AppSettings["KalturaPartnerID"].ToString() %>';
            expiry = '<%=ConfigurationManager.AppSettings["KalturaSessionExpiry"].ToString() %>';
            var type = KalturaSessionType.ADMIN;
            mediaPlayerId = '<%=ConfigurationManager.AppSettings["KalturaMediaPlayerID"].ToString() %>';
            flag = 0;
            mediaId = getQueryStringParameter('mediaId');
            categoryName = getQueryStringParameter('categoryName');
            mediaDescriptn = '<%= Resources.Resource.KalturaMediaDescription %>';
            playVideoPageURL = '<%=ConfigurationManager.AppSettings["KalturaPlayVideosPageURL"].ToString() %>';
            filterPageSize = '<%=ConfigurationManager.AppSettings["KalturaFilterPageSize"].ToString() %>';
            var relatedVideosTitle = document.getElementById('spanRelatedVideos');
            relatedVideosTitle.innerHTML = "<label>" + '<%= Resources.Resource.KalturaRelatedVideosTitle %>' + "</label>";

            var relatedVideosTitle = document.getElementById('spanRelatedVideos_Res');
            relatedVideosTitle.innerHTML = "<label>" + '<%= Resources.Resource.KalturaRelatedVideosTitle %>' + "</label>";

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
            mediaName.innerHTML = "<span class='spanNameofVideo'>" + result.name + "</span>";

            //Get related media
            var filter = new KalturaMediaEntryFilter();
            filter.advancedSearch = new KalturaCategoryEntryAdvancedFilter();
            filter.orderBy = "-recent";
            filter.mediaTypeEqual = KalturaMediaType.VIDEO;
            filter.statusIn = String(2);
            //Based on category name
            filter.tagsMultiLikeOr = String(decodeURI(categoryName));
            filter.tagsMultiLikeAnd = String(decodeURI(categoryName));
            //Based on media name
            //filter.nameMultiLikeOr = result.name;
            //filter.nameMultiLikeAnd = result.name;
            var pager = new KalturaFilterPager();
            pager.pageSize = parseInt(filterPageSize);
            var relatedMedia = client.media.listAction(onGetRelatedMediaInfoSuccess, filter, pager);
        }

        function handleRelatedMediaInfo(result) {
            if (result.objects.length > 0) {
                for (var i = 0; i < result.objects.length; i++) {
                    var timeDuration = msToTime(result.objects[i].msDuration);
                    element = document.getElementById("kaltura_Related_Media");
                    element.innerHTML += "<tr><td class='tdRelatedVideosThumbnail' style='vertical-align:top !important;'><div class='relatedVideosConstant relatedVideos'><a class='anchorStyle' href='" + playVideoPageURL + "?mediaId=" + result.objects[i].id + "&categoryName=" + categoryName + "'><img aria-hidden='true' alt='" + result.objects[i].name + "' src='" + result.objects[i].thumbnailUrl + "/width/90/'/><span class='video-timeforRelatedVideos' aria-hidden='true'>" + timeDuration + "</span></a></div></td>" + "<td class='tdRelatedVideosName'><a class='anchorRelatedVideoNameColor' href='" + playVideoPageURL + "?mediaId=" + result.objects[i].id + "&categoryName=" + categoryName + "'>" + result.objects[i].name + "</a></td></tr>";
                    //For Responsive
                    element = document.getElementById("kaltura_Related_Media_Res");
                    element.innerHTML += "<tr><td class='tdRelatedVideosThumbnail' style='vertical-align:top !important;'><div class='relatedVideosConstant relatedVideos'><a class='anchorStyle' href='" + playVideoPageURL + "?mediaId=" + result.objects[i].id + "&categoryName=" + categoryName + "'><img aria-hidden='true' alt='" + result.objects[i].name + "' src='" + result.objects[i].thumbnailUrl + "/width/90/'/><span class='video-timeforRelatedVideos' aria-hidden='true'>" + timeDuration + "</span></a></div></td>" + "<td class='tdRelatedVideosName'><a class='anchorRelatedVideoNameColor' href='" + playVideoPageURL + "?mediaId=" + result.objects[i].id + "&categoryName=" + categoryName + "'>" + result.objects[i].name + "</a></td></tr>";
                }
            }
            else {
                element = document.getElementById("kaltura_Related_Media");
                element.innerHTML = "<span class='spanRelatedVideos'>" + '<%= Resources.Resource.KalturaRelatedVideosDescription %>' + "</span>";

                //For Responsive
                element = document.getElementById("kaltura_Related_Media_Res");
                element.innerHTML = "<span class='spanRelatedVideos'>" + '<%= Resources.Resource.KalturaRelatedVideosDescription %>' + "</span>";
            }
        }

        function msToTime(duration) {
            if (duration > 0) {
                var milliseconds = parseInt((duration % 1000) / 100)
                    , seconds = parseInt((duration / 1000) % 60)
                    , minutes = parseInt((duration / (1000 * 60)) % 60)
                    , hours = parseInt((duration / (1000 * 60 * 60)) % 24);

                hours = (hours < 10) ? "0" + hours : hours;
                minutes = (minutes < 10) ? "0" + minutes : minutes;
                seconds = (seconds < 10) ? "0" + seconds : seconds;

                if (hours == 0) {
                    return minutes + ":" + seconds;
                }
                else {
                    return hours + ":" + minutes + ":" + seconds;
                }
            }
            return "00:00";
        }

        $(document).ready(function () {
            initialize_PlayVideos();
        });

        window.onload = setTimeout(function () {
            var kSessionEnd = client.session.end(onKalturaSessionEndSuccess);
        }, 25000);
    </script>
</portal:OuterWrapperPanel>