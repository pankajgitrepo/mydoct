<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Kaltura_HowToVideo.ascx.cs" Inherits="mojoPortal.Web.Century21_Kaltura.Kaltura_HowToVideo" %>

<portal:OuterWrapperPanel ID="pnlOuterWrap" runat="server">
    <mp:CornerRounderTop ID="ctop1" runat="server" EnableViewState="false" />
    <portal:InnerWrapperPanel ID="pnlInnerWrap" runat="server" CssClass="panelwrapper linksmodule">
        <%-- <portal:ModuleTitleControl ID="Title1" runat="server" EnableViewState="false" />
        <portal:OuterBodyPanel ID="pnlOuterBody" runat="server">--%>
        <portal:InnerBodyPanel ID="pnlInnerBody" runat="server" CssClass="modulecontent">
            <div id="kaltura_media_all_categories">
            </div>
        </portal:InnerBodyPanel>
        <%--   </portal:OuterBodyPanel>--%>
    </portal:InnerWrapperPanel>
    <mp:CornerRounderBottom ID="cbottom1" runat="server" EnableViewState="false" />
    <script type="text/javascript">
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
        var onGetCategoryMediaInfoSuccess = function (success, results) {
            if (!success)
                alert(results);

            if (results.code && results.message) {
                alert(results.message);
                return;
            }
            //debugger;
            handleCategoryMediaInfo(results);
        };
        var onGetMediaBasedOnCategoryPrivateSuccess = function (success, results) {
            if (!success)
                alert(results);

            if (results.code && results.message) {
                alert(results.message);
                return;
            }
            
            handleMediaBasedOnCategoryPrivate(results);
        }

        var onGetAllCategoriesSuccess = function (success, results) {
            if (!success)
                alert(results);

            if (results.code && results.message) {
                alert(results.message);
                return;
            }
            handleAllCategories(results);
        }


        var kalturaPlayer = null;
        var serviceUrl = null;
        var secret = null;
        var userId = null;
        var partnerId = null;
        var expiry = null;
        var mediaPlayerId = null;
        var flag = null;
        var element = null;
        var redirectURL = null;
        var privateCategoryNames = null;
        var privateCategoryIDs = null;
        var excludePublicCategory = null;
        var filterPageSize = null;
        var client = null;
        var favouriteImageUrl = null;
        var favouriteChannelName = null;
        var recentlyAddedChannelName = null;
        var top10ViewedChannelName = null;
        var categoryMediaEntryId = null;
        var categoryDepth = null;
        //Read and initialize kaltura settings from web.config
        function initiliaze_HowToVideo() {
            kalturaPlayer = '<%=ConfigurationManager.AppSettings["kalturaPlayer"].ToString() %>';
            serviceUrl = '<%=ConfigurationManager.AppSettings["KalturaServiceUrl"].ToString() %>';
            secret = '<%=ConfigurationManager.AppSettings["KalturaAdminSecret"].ToString() %>';
            userId = '<%=ConfigurationManager.AppSettings["KalturaUserID"].ToString() %>';
            partnerId = '<%=ConfigurationManager.AppSettings["KalturaPartnerID"].ToString() %>';
            expiry = '<%=ConfigurationManager.AppSettings["KalturaSessionExpiry"].ToString() %>';
            var type = KalturaSessionType.ADMIN;
            mediaPlayerId = '<%=ConfigurationManager.AppSettings["KalturaMediaPlayerID"].ToString() %>';
            flag = 0;
            redirectURL = '<%=ConfigurationManager.AppSettings["KalturaDisplayAllChannelsPageURL"].ToString() %>';
            excludePublicCategory = '<%=ConfigurationManager.AppSettings["KalturaPublicChannelFullName"].ToString() %>';
            filterPageSize = '<%=ConfigurationManager.AppSettings["KalturaFilterPageSize"].ToString() %>';

            favouriteImageUrl = '<%=ConfigurationManager.AppSettings["KalturaFavouriteImageUrl"].ToString() %>';
            recentAddedImageUrl = '<%=ConfigurationManager.AppSettings["KalturaRecentlyAddedImageUrl"].ToString() %>';
            topViewImageUrl = '<%=ConfigurationManager.AppSettings["KalturaTopViewedImageUrl"].ToString() %>';
            favouriteChannelName = '<%=Resources.Resource.KalturaFavouriteChannelName %>';
            recentlyAddedChannelName = 'Recently Added';
            top10ViewedChannelName = 'Top 10 Viewed';

            //Get kaltura session
            var config = new KalturaConfiguration(parseInt(partnerId));
            config.serviceUrl = '<%=ConfigurationManager.AppSettings["KalturaConfigServiceURL"].ToString() %>';
            client = new KalturaClient(config);
            var privileges = null;
            
            var kSessionStart = client.session.start(onGetKalturaSessionSuccess, secret, userId, type, parseInt(partnerId), parseInt(expiry), privileges);
        }

        function handleSession(results) {
            client.setKs(results);
            var filter = new KalturaCategoryEntryFilter();
            filter.relatedObjects = new Array();
            filter.statusEqual = KalturaCategoryStatus.ACTIVE;
            filter.orderBy = "+name";
            var pager = new KalturaFilterPager();
            pager.pageSize = parseInt(filterPageSize);
            var getAllCategories = client.category.listAction(onGetAllCategoriesSuccess, filter, pager);
        }

        function handleMediaBasedOnCategoryPrivate(result) {
            //debugger;

            for (var i = 0; i < result.objects.length; i++) {
                var index = privateCategoryIDs.indexOf(result.objects[i].fullIds);
                if (index != -1) {
                    element = document.getElementById('kaltura_media_all_categories');
                    element.innerHTML += "<div class='grow pic'><div class='divHowToVideoCaptionPosition'><a href='" + redirectURL + "?id=" + privateCategoryIDs[index].split('>')[3] + "&categoryName=" + privateCategoryNames[index].split('>')[3] + "'><img alt='' src=" + serviceUrl + "/p/" + partnerId + "/sp/" + partnerId + "00/thumbnail/entry_id/" + categoryMediaEntryId + "/version/100001/width/500/'/></a></div><br/><div class='divHowToVideoCategoryName'><label>" + privateCategoryNames[index].split('>')[3] + "</label></div></div>";
                    //flag++;
                }
            }
        }

        function handleCategoryMediaInfo(result) {
            //element = document.getElementById("kaltura_media_by_category");
            //element.innerHTML = '';
            //var privateChannelName = '<%=ConfigurationManager.AppSettings["KalturaPrivateChannelFullName"].ToString() %>';
                    ////var channelName = null;
                    //var searchString = null;
                    //debugger;
                    for (var i = 0; i < result.objects.length; i++) {
                        categoryMediaEntryId = result.objects[i].entryId;
                        //var index = privateCategoryIDs.indexOf(result.objects[i].categoryFullIds.substring(0, result.objects[i].categoryFullIds.length - String(result.objects[i].categoryId).length - 1));
                        var index = privateCategoryIDs.indexOf(result.objects[i].categoryFullIds);
                        if (index != -1) {
                            var categoryDepthLevel = '';
                            for (var k = 0; k < categoryDepth.length; k++) {
                                if (typeof (categoryDepth[k]) !== 'undefined') {
                                    var depth = categoryDepth[k].split(',');
                                    if (depth[1].toString() === result.objects[i].categoryId.toString()) {
                                        categoryDepthLevel = 4;//depth[0];
                                    }
                                }
                                
                            }
                            element = document.getElementById('kaltura_media_all_categories');
                            if (categoryDepthLevel === '') {
                                element.innerHTML += "<div class='grow pic'><div class='divHowToVideoCaptionPosition'><a href='" + redirectURL + "?id=" + privateCategoryIDs[index].split('>')[3] + "&categoryName=" + privateCategoryNames[index].split('>')[3] + "'><img alt='' src=" + serviceUrl + "/p/" + partnerId + "/sp/" + partnerId + "00/thumbnail/entry_id/" + result.objects[i].entryId + "/version/100001/width/500/'/></a></div><br/><div class='divHowToVideoCategoryName'><label>" + privateCategoryNames[index].split('>')[3] + "</label></div></div>";
                            }
                            else {
                                element.innerHTML += "<div class='grow pic'><div class='divHowToVideoCaptionPosition'><a href='" + redirectURL + "?id=" + privateCategoryIDs[index].split('>')[3] + "&categoryDepth=" + categoryDepthLevel + "&categoryName=" + privateCategoryNames[index].split('>')[3] + "'><img alt='' src=" + serviceUrl + "/p/" + partnerId + "/sp/" + partnerId + "00/thumbnail/entry_id/" + result.objects[i].entryId + "/version/100001/width/500/'/></a></div><br/><div class='divHowToVideoCategoryName'><label>" + privateCategoryNames[index].split('>')[3] + "</label></div></div>";
                            }
                            
                            
                            //flag++;
                        }
                        //element.innerHTML += "<div class='constant picConstant'><div class='maindDivViewsAndLength'><div class='divViewsAndLengthOfVideo'><b><label class='views'><span>" + videoViews + "</span>  |  " + timeDuration + "</label></b></div></div><div class='divImageThumbnail'><a href='" + playVideoPageURL + "?mediaId=" + result.objects[i].id + "&categoryName=" + categoryName + "'><img alt='" + result.objects[i].name + "' src='" + result.objects[i].thumbnailUrl + "/width/400/'/></a></div><br/><div class='divNameOfVideo'><label class='labelNameOfVideo'>" + result.objects[i].name + "</label></div></div>";

                    }
                }
        function handleCategorySession(results) {
            //debugger;
            client.setKs(results);
            var filter = new KalturaCategoryEntryFilter();
            filter.orderBy = "-recent"
            filter.advancedSearch = new KalturaCategoryEntryAdvancedFilter();
            if (results.totalCount > 0) {
                filter.categoriesIdsMatchAnd = String(results.objects[0].id);
            }
            filter.mediaTypeEqual = KalturaMediaType.VIDEO;
            filter.statusIn = String(2);

            var pager = new KalturaFilterPager();
            pager.pageSize = parseInt(filterPageSize);
            var result = client.media.listAction(onGetCategoryMediaInfoSuccess, filter, pager);
        }



        function handleAllCategories(result) {
            var privateChannelID = null;
            var privateChannelName = '<%=ConfigurationManager.AppSettings["KalturaPrivateChannelFullName"].ToString() %>';
            var channelName = null;
            var searchString = null;
            privateCategoryIDs = new Array();
            privateCategoryNames = new Array();
            categoryDepth = new Array();
            var icategoryDepth = 0;
            flag = 0;
            //debugger;
            for (var i = 0; i < result.objects.length; i++) {
                channelName = result.objects[i].fullName;
                searchString = channelName.indexOf(privateChannelName);
                
                if (searchString != -1) {
                    if (result.objects[i].fullName != excludePublicCategory) {
                        if (result.objects[i].depth == 3) { //added code by sandeepku on 4/23/2018
                            
                            if (result.objects[i].directSubCategoriesCount != 0 || result.objects[i].directEntriesCount != 0) {
                                privateCategoryIDs[flag] = result.objects[i].fullIds;
                                privateCategoryNames[flag] = result.objects[i].fullName;
                                if (result.objects[i].directSubCategoriesCount === 0 && result.objects[i].directEntriesCount !== 0) {
                                    //debugger;
                                    if (categoryDepth.length === 0) {
                                        icategoryDepth = 0
                                    }
                                    else {
                                        icategoryDepth = categoryDepth.length + 1;
                                    }
                                    categoryDepth[icategoryDepth] = result.objects[i].depth + "," + result.objects[i].id;
                                }
                                flag++;
                            }
                        }
                    }
                }
            }
            flag = 0;
            //debugger;
            for (var i = 0; i < privateCategoryIDs.length; i++) {
                var filter = new KalturaCategoryEntryFilter();
                filter.relatedObjects = new Array();
                //filter.orderBy = "-recent";
                filter.orderBy = "+depth";
                filter.advancedSearch = new KalturaCategoryEntryAdvancedFilter();
                
                //filter.fullIdsEqual = String(privateCategoryIDs[i]);
                //filter.fullIdsStartsWith = String(privateCategoryIDs[i]);
                filter.categoryFullIdsStartsWith = String(privateCategoryIDs[i]);
                filter.depthEqual = 3;
                var pager = new KalturaFilterPager();
                pager.relatedObjects = new Array();
                pager.pageSize = 1;
                
                //var mediaBasedOnCategory = client.categoryEntry.listAction(onGetMediaBasedOnCategoryPrivateSuccess, filter, pager);
                //var mediaBasedOnCategory = client.category.listAction(onGetMediaBasedOnCategoryPrivateSuccess, filter, pager);
                var mediaBasedOnCategoryMedia = client.categoryEntry.listAction(onGetCategoryMediaInfoSuccess, filter, pager);

                
            }
            //debugger;
            element = document.getElementById('kaltura_media_all_categories');
            element.innerHTML += "<div class='grow pic'><div class='divHowToVideoCaptionPosition'><a href='" + redirectURL + "?id=1&categoryName=" + favouriteChannelName + "'><img alt='' src='" + favouriteImageUrl + "'/></a></div><br/><div class='divHowToVideoCategoryName'><label>Favorites</label></div></div>";
            element.innerHTML += "<div class='grow pic'><div class='divHowToVideoCaptionPosition'><a href='" + redirectURL + "?id=-1&categoryName=" + recentlyAddedChannelName + "'><img alt='' src='" + recentAddedImageUrl + "'/></a></div><br/><div class='divHowToVideoCategoryName'><label>Recently Added</label></div></div>";
            element.innerHTML += "<div class='grow pic'><div class='divHowToVideoCaptionPosition'><a href='" + redirectURL + "?id=-2&categoryName=" + top10ViewedChannelName + "'><img alt='' src='" + topViewImageUrl + "'/></a></div><br/><div class='divHowToVideoCategoryName'><label>Top 10 Viewed</label></div></div>";
        }

        $(document).ready(function () {
            var header = $(".modulecontent");
            header.removeClass("modulecontent");
            header.addClass("modulecontentForKaltura");
            initiliaze_HowToVideo();
        });

        window.onload = setTimeout(function () {
            var kSessionEnd = client.session.end(onKalturaSessionEndSuccess);
        }, 25000);
    </script>
</portal:OuterWrapperPanel>


