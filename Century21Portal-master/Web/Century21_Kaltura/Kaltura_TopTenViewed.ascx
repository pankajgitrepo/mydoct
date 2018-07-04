<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Kaltura_TopTenViewed.ascx.cs" Inherits="mojoPortal.Web.Century21_Kaltura.Kaltura_TopTenViewed" %>
<portal:OuterWrapperPanel ID="pnlOuterWrap" runat="server">
    <mp:CornerRounderTop ID="ctop1" runat="server" EnableViewState="false" />
    <portal:InnerWrapperPanel ID="pnlInnerWrap" runat="server" CssClass="panelwrapper linksmodule">
        <%-- <portal:ModuleTitleControl ID="Title1" runat="server" EnableViewState="false" />--%>
        <%--<portal:OuterBodyPanel ID="pnlOuterBody" runat="server">--%>
        <portal:InnerBodyPanel ID="pnlInnerBody" runat="server" CssClass="modulecontent">
            <div id="chkToggle" style="padding-left: 2%; height: 18px;display:none;">
                <label class="switch">
                    <input type="checkbox" class="switch-input" id="chkSortOptions" checked="checked">
                    <span class="switch-label" data-on="Most Recent" data-off="Alphabetical"></span>
                    <span class="switch-handle"></span>
                </label>
            </div>
            <br />
            <div id="kaltura_media_by_category" class="mainwrapper">
            </div>
            <div><asp:Label ID="lblNoFavourites" runat="server" Visible="false" CssClass="spanNameofVideo"></asp:Label></div>
            <asp:HiddenField ID="mediaIdList" runat="server" Value="Default" ClientIDMode="Static"></asp:HiddenField>
        </portal:InnerBodyPanel>
        <%-- </portal:OuterBodyPanel>--%>
    </portal:InnerWrapperPanel>
    <mp:CornerRounderBottom ID="cbottom1" runat="server" EnableViewState="false" />

    <style type="text/css">
        label {
            font-size: 11px;
            padding: .4em 0;
            color: #fff;
        }

            label.views span {
                padding-left: 21px;
                background: url(Data/Sites/1/skins/Theme_C21/images/view_icon.jpg) no-repeat left center;
            }
    </style>

    <script type="text/javascript">
        var onKalturaSessionEndSuccess = function (success, results) {
            if (!success)
                alert(results);
        };

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

        var onGetKalturaSessionSuccessforFavourites = function (success, results) {
            if (!success)
                alert(results);

            if (results.code && results.message) {
                alert(results.message);
                return;
            }
            handleSessionforFavourites(results);
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

        var onhandleSessionforFavouritesSuccess = function (success, results) {
            if (!success)
                alert(results);

            if (results.code && results.message) {
                alert(results.message);
                return;
            }
            handleFavouriteMediaInfo(results);
        };

        var kalturaPlayer = null;
        var serviceUrl = null;
        var secret = null;
        var userId = null;
        var partnerId = null;
        var expiry = null;
        var mediaPlayerId = null;
        var playVideoPageURL = null;
        var filterPageSize = null;
        var flag = null;
        var element = null;
        var categoryId = null;
        var categoryName = null;
        var checkBoxValue = null;
        var mediaIdList = null;
        var mediaIdListArray = null;
        var client = null;

        //Read and initialize kaltura settings from web.config
        function initialize_DisplayVideosByCategory(sortOrder) {
            kalturaPlayer = '<%=ConfigurationManager.AppSettings["kalturaPlayer"].ToString() %>';
            serviceUrl = '<%=ConfigurationManager.AppSettings["KalturaServiceUrl"].ToString() %>';
            secret = '<%=ConfigurationManager.AppSettings["KalturaAdminSecret"].ToString() %>';
            userId = '<%=ConfigurationManager.AppSettings["KalturaUserID"].ToString() %>';
            partnerId = '<%=ConfigurationManager.AppSettings["KalturaPartnerID"].ToString() %>';
            expiry = '<%=ConfigurationManager.AppSettings["KalturaSessionExpiry"].ToString() %>';
            var type = KalturaSessionType.ADMIN;
            mediaPlayerId = '<%=ConfigurationManager.AppSettings["KalturaMediaPlayerID"].ToString() %>';
            playVideoPageURL = '<%=ConfigurationManager.AppSettings["KalturaPlayVideosPageURL"].ToString() %>';
            filterPageSize = '<%=ConfigurationManager.AppSettings["KalturaFilterPageSize"].ToString() %>';
            flag = 0;
            categoryId = getQueryStringParameter('id');
            categoryName = getQueryStringParameter('categoryName');
            checkBoxValue = sortOrder;
            mediaIdList = $("#mediaIdList").val();

            //Get kaltura session
            var config = new KalturaConfiguration(parseInt(partnerId));
            config.serviceUrl = '<%=ConfigurationManager.AppSettings["KalturaConfigServiceURL"].ToString() %>';
            client = new KalturaClient(config);
            var privileges = null;
            if ((categoryId != null) && (categoryId != 1)) {
                var kSessionStart = client.session.start(onGetKalturaSessionSuccess, secret, userId, type, parseInt(partnerId), parseInt(expiry), privileges);
            }
            else if (categoryId == 1) {
                var header = $(".modulecontentForKaltura");
                header.removeClass("modulecontentForKaltura");
                header.addClass("modulecontentForKalturaFavourites");
                document.getElementById("chkToggle").style.display = "none";
                if (mediaIdList != "Default") {
                    mediaIdListArray = new Array();
                    mediaIdListArray = mediaIdList.split(',');
                    var kSessionStart = client.session.start(onGetKalturaSessionSuccessforFavourites, secret, userId, type, parseInt(partnerId), parseInt(expiry), privileges);
                }
            }
            else {
                var kSessionStart = client.session.start(onGetKalturaSessionSuccess, secret, userId, type, parseInt(partnerId), parseInt(expiry), privileges);
            }
        }

        function handleSession(results) {
            client.setKs(results);
            var filter = new KalturaCategoryEntryFilter();
            filter.orderBy = checkBoxValue;
            filter.advancedSearch = new KalturaCategoryEntryAdvancedFilter();
            //filter.categoriesIdsMatchAnd = String(categoryId);
            filter.mediaTypeEqual = KalturaMediaType.VIDEO;
            filter.statusIn = String(2);

            var pager = new KalturaFilterPager();
            //pager.pageSize = parseInt(filterPageSize);
            pager.pageSize = 10;
            var result = client.media.listAction(onGetMediaInfoSuccess, filter, pager);
        }

        function handleSessionforFavourites(results) {
            client.setKs(results);
            var version = null;
            for (var i = 0; i < mediaIdListArray.length; i++) {
                var result = client.media.get(onhandleSessionforFavouritesSuccess, mediaIdListArray[i], version);
            }
        }

        function handleMediaInfo(result) {
            element = document.getElementById("kaltura_media_by_category");
            element.innerHTML = '';
            for (var i = 0; i < result.objects.length; i++) {
                var videoViews = result.objects[i].plays;
                var timeDuration = msToTime(result.objects[i].msDuration);
                element = document.getElementById("kaltura_media_by_category");
                element.innerHTML += "<div class='constant picConstant'><div class='maindDivViewsAndLength'><div class='divViewsAndLengthOfVideo'><b><label class='views'><span>" + videoViews + "</span>  |  " + timeDuration + "</label></b></div></div><div class='divImageThumbnail'><a href='" + playVideoPageURL + "?mediaId=" + result.objects[i].id + "&categoryName=" + categoryName + "'><img alt='" + result.objects[i].name + "' src='" + result.objects[i].thumbnailUrl + "/width/400/'/></a></div><br/><div class='divNameOfVideo'><label class='labelNameOfVideo'>" + result.objects[i].name + "</label></div></div>";
            }
        }

        function handleFavouriteMediaInfo(result) {
            element = document.getElementById("kaltura_media_by_category");
            var videoViews = result.plays;
            var timeDuration = msToTime(result.msDuration);
            element = document.getElementById("kaltura_media_by_category");
            element.innerHTML += "<div class='constant picConstant'><div class='maindDivViewsAndLength'><div class='divViewsAndLengthOfVideo'><b><label class='views'><span>" + videoViews + "</span>  |  " + timeDuration + "</label></b></div></div><div class='divImageThumbnail'><a href='" + playVideoPageURL + "?mediaId=" + result.id + "&categoryName=" + categoryName + "'><img alt='" + result.name + "' src='" + result.thumbnailUrl + "/width/400/'/></a></div><br/><div class='divNameOfVideo'><label class='labelNameOfVideo'>" + result.name + "</label></div></div>";
        }

        function handleMediaBasedOnSubCategory(result) {
            for (var i = 0; i < result.objects.length; i++) {
                var media = client.media.get(onGetMediaInfoSuccess, result.objects[i].entryId, null);
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
            //$('#chkSortOptions').change(function () {
            //    if (document.getElementById("chkSortOptions").checked == false) {
            //        initialize_DisplayVideosByCategory('+name');
            //    }
            //    else {
            //        initialize_DisplayVideosByCategory('-recent');
            //    }
            //});
            var header = $(".modulecontent");
            header.removeClass("modulecontent");
            header.addClass("modulecontentForKaltura");
            initialize_DisplayVideosByCategory('-plays');

        });

        window.onload = setTimeout(function () {
            var kSessionEnd = client.session.end(onKalturaSessionEndSuccess);
        }, 25000);
    </script>
</portal:OuterWrapperPanel>