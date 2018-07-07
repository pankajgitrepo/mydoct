<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Kaltura_DisplayVideosByCategory.ascx.cs" Inherits="mojoPortal.Web.Century21_Kaltura.Kaltura_DisplayVideosByCategory1" %>

<portal:OuterWrapperPanel ID="pnlOuterWrap" runat="server">
    <mp:CornerRounderTop ID="ctop1" runat="server" EnableViewState="false" />
    <portal:InnerWrapperPanel ID="pnlInnerWrap" runat="server" CssClass="panelwrapper linksmodule">
        <%-- <portal:ModuleTitleControl ID="Title1" runat="server" EnableViewState="false" />--%>
        <%--<portal:OuterBodyPanel ID="pnlOuterBody" runat="server">--%>
        <portal:InnerBodyPanel ID="pnlInnerBody" runat="server" CssClass="modulecontent">
            <div id="chkToggle" style="padding-left: 2%; height: 18px;">
                <label class="switch">
                    <input type="checkbox" class="switch-input" id="chkSortOptions" checked="checked">
                    <span class="switch-label" data-on="Most Recent" data-off="Alphabetical"></span>
                    <span class="switch-handle"></span>
                </label>
                <input type="button" id="uploadUGC" class="cbVideoIframe" value="Upload User Generated Content" style="display:none;" />
                <a class="cbVideoIframe" id ="infoVideo" href="#" > Upload User Generated Content </a>
            </div>
            <br />
            <div id="kaltura_media_by_category" class="mainwrapper">
            </div>
            <div id="kaltura_media_all_subcategories">
            </div>
            <div id="errormsg" style="display:none;color:red;">
                There is no video associated with this subcategory.
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

        var onGetKalturaSessionSuccessforRecentAdded = function (success, results) {
            if (!success)
                alert(results);

            if (results.code && results.message) {
                alert(results.message);
                return;
            }
            handleSessionforRecentAdded(results);
        };

        var onGetKalturaSessionSuccessforTopTenViewed = function (success, results) {
            if (!success)
                alert(results);

            if (results.code && results.message) {
                alert(results.message);
                return;
            }
            handleSessionforTopTenViewed(results);
        };

        var onGetKalturaSessionSuccess = function (success, results) {
            if (!success)
                alert(results);

            if (results.code && results.message) {
                alert(results.message);
                return;
            }
            handleSubCatSession(results);
            //debugger;
            if (categoryDepth != undefined && categoryDepth == 4) {
                handleSession(results);
            }
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

        var onhandleSessionforRecentAddedSuccess = function (success, results) {
            if (!success)
                alert(results);

            if (results.code && results.message) {
                alert(results.message);
                return;
            }
            handleRecentAddedMediaInfo(results);
        };

        var onhandleSessionforTopTenViewedSuccess = function (success, results) {
            if (!success)
                alert(results);

            if (results.code && results.message) {
                alert(results.message);
                return;
            }
            handleTopTenViewedMediaInfo(results);
        };

        var onGetAllCategoriesSuccess = function (success, results) {
            if (!success)
                alert(results);

            if (results.code && results.message) {
                alert(results.message);
                return;
            }
            handleMediaInfo(results);
        }

        var onGetMediaBasedOnCategoryPrivateSuccess = function (success, results) {
            if (!success)
                alert(results);

            if (results.code && results.message) {
                alert(results.message);
                return;
            }
            handleMediaBasedOnCategoryPrivate(results);
        }

        var onGetAllPlaylistVideoSuccess = function (success, results) {
            if (!success)
                alert(results);

            if (results.code && results.message) {
                alert(results.message);
                return;
            }
            handleMediaInfo(results);
        }

        var onGetSubCategoryMediaInfoSuccess = function (success, results) {
            if (!success)
                alert(results);

            if (results.code && results.message) {
                alert(results.message);
                return;
            }
            //debugger;
            handleSubCategoryMediaInfo(results);
        };

        var onGetAllSubCategoriesSuccess = function (success, results) {
            ///debugger;
            if (!success)
                alert(results);

            if (results.code && results.message) {
                alert(results.message);
                return;
            }
            //handleAllCategories(results);
            handleSubCategorySession(results);
            //handleSubCategoryMediaInfo(results);
        }

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
        var excludePublicCategory = null;
        var privateChannelID = null;
        var privateFullChannelID = null;
        var privateCategoryNames = null;
        var privateCategoryIDs = null;
        var redirectURL = null;
        var element = null;
        var categoryDepth = null;
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
            excludePublicCategory = '<%=ConfigurationManager.AppSettings["KalturaPublicChannelFullName"].ToString() %>';
            redirectURL = '<%=ConfigurationManager.AppSettings["KalturaDisplayAllChannelsPageURL"].ToString() %>';
            flag = 0;
            categoryId = getQueryStringParameter('id');
            categoryName = getQueryStringParameter('categoryName');
            categoryDepth = getQueryStringParameter('categoryDepth');
            checkBoxValue = sortOrder;
            mediaIdList = $("#mediaIdList").val();

            //Get kaltura session
            var config = new KalturaConfiguration(parseInt(partnerId));
            config.serviceUrl = '<%=ConfigurationManager.AppSettings["KalturaConfigServiceURL"].ToString() %>';
            client = new KalturaClient(config);
            //debugger;
            var privileges = null;
            if ((categoryId != null) && (categoryId != 1) && (categoryId != -1) && (categoryId != -2)) {
                document.getElementById("chkToggle").style.display = "none";
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
            else if (categoryId == -1) {
                var header = $(".modulecontentForKaltura");
                header.removeClass("modulecontentForKaltura");
                header.addClass("modulecontentForKalturaFavourites");
                document.getElementById("chkToggle").style.display = "none";
                //var kSessionStart = client.session.start(onGetKalturaSessionSuccessforRecentAdded, secret, userId, type, parseInt(partnerId), parseInt(expiry), privileges);
                var kSessionStart = client.session.start(onGetKalturaSessionSuccessforPlaylistRecentAdded, secret, userId, type, parseInt(partnerId), parseInt(expiry), privileges);
                
            }
            else if (categoryId == -2) {
                var header = $(".modulecontentForKaltura");
                header.removeClass("modulecontentForKaltura");
                header.addClass("modulecontentForKalturaFavourites");
                document.getElementById("chkToggle").style.display = "none";
                var kSessionStart = client.session.start(onGetKalturaSessionSuccessforTopTenViewed, secret, userId, type, parseInt(partnerId), parseInt(expiry), privileges);
            }
        }

        function handleSession(results) {
            //debugger;
            client.setKs(results);
            var filter = new KalturaCategoryEntryFilter();
            filter.orderBy = checkBoxValue;
            filter.advancedSearch = new KalturaCategoryEntryAdvancedFilter();
            filter.categoriesIdsMatchAnd = String(categoryId);
            filter.mediaTypeEqual = KalturaMediaType.VIDEO;
            filter.statusIn = String(2);
            
            var pager = new KalturaFilterPager();
            pager.pageSize = parseInt(filterPageSize);
            var result = client.media.listAction(onGetMediaInfoSuccess, filter, pager);
        }

        //sub category
        function handleSubCatSession(results) {
            //debugger;
            client.setKs(results);
            //var filter = new KalturaCategoryEntryFilter();
            var filter = new KalturaCategoryFilter();
            //var filter.parentIdEqual = 19136931;
            filter.relatedObjects = new Array();
            filter.statusEqual = KalturaCategoryStatus.ACTIVE;
            filter.parentIdEqual = String(categoryId);
            filter.orderBy = "+name";
            var pager = new KalturaFilterPager();
            pager.pageSize = parseInt(filterPageSize);
            var getAllCategories = client.category.listAction(onGetAllSubCategoriesSuccess, filter, pager);
        }

        function handleSubCategorySession(result) {
            //debugger;
            //client.setKs(result);

            var privateChannelID = null;
            var privateChannelName = '<%=ConfigurationManager.AppSettings["KalturaPrivateChannelFullName"].ToString() %>';
            var channelName = null;
            var searchString = null;
            privateCategoryIDs = new Array();
            privateCategoryNames = new Array();
            flag = 0;
            //debugger;
            for (var i = 0; i < result.objects.length; i++) {
                channelName = result.objects[i].fullName;
                searchString = channelName.indexOf(privateChannelName);

                if (searchString != -1) {
                    if (result.objects[i].fullName != excludePublicCategory) {
                        if (result.objects[i].depth == 4) { //added code by sandeepku on 4/23/2018
                            //if (result.objects[i].id == categoryId) { //20653941) {
                            if (result.objects[i].directEntriesCount > 0) {
                                //alert(" Depth 4 - 20653941 found commercial category Id " + categoryId);
                                privateCategoryIDs[flag] = result.objects[i].fullIds;
                                privateCategoryNames[flag] = result.objects[i].fullName;
                                flag++;
                            }
                            //}
                        }
                            //if (result.objects[i].depth == 3) { //added code by sandeepku on 4/23/2018
                            //    if (result.objects[i].id == categoryId) {//categoryId) {
                            //       // alert(i);
                            //        //alert(" Depth 3 - 20653941 found commercial");
                            //        if (result.objects[i].directSubCategoriesCount == 0) {
                            //            privateCategoryIDs = [];// result.objects[i].fullIds;
                            //            privateCategoryNames = []; //result.objects[i].fullName;
                            //            flag++;
                            //        }
                            //        else {
                            //            privateCategoryIDs[flag] = result.objects[i].fullIds;
                            //            privateCategoryNames[flag] = result.objects[i].fullName;
                            //            flag++;
                            //        }
                            //    }
                            //}
                    }
                }
            }
            //debugger;
            for (var i = 0; i < privateCategoryIDs.length; i++) {
                //if (categoryDepth == 4) {
                
                    var filter = new KalturaCategoryEntryFilter();
                    filter.orderBy = "-recent"
                    filter.advancedSearch = new KalturaCategoryEntryAdvancedFilter();
                    if (result.totalCount > 0) {
                        //filter.categoriesIdsMatchAnd = String(result.objects[i].id);
                        filter.categoryFullIdsStartsWith = String(privateCategoryIDs[i]);
                    }
                    //if (result.totalCount > 0) {
                    //    filter.categoriesIdsMatchAnd = String(categoryId);
                    //}
                    //filter.categoriesIdsMatchAnd = String(categoryId);
                    //filter.parentIdEqual = String(categoryId);
                    filter.mediaTypeEqual = KalturaMediaType.VIDEO;
                    filter.statusIn = String(2);

                    var pager = new KalturaFilterPager();
                    pager.pageSize = parseInt(filterPageSize);
                    //var results = client.media.listAction(onGetSubCategoryMediaInfoSuccess, filter, pager);
                    var results = client.categoryEntry.listAction(onGetSubCategoryMediaInfoSuccess, filter, pager);
                    //var results = client.category.listAction(onGetSubCategoryMediaInfoSuccess, filter, pager);
                //}
            }
            $('#errormsg').hide();
            if (privateCategoryIDs.length == 0)
            {
                //debugger;
                if (categoryDepth == undefined)
                    $('#errormsg').show();

            }
        }
        //Sub category

        function handleSessionforFavourites(results) {
            client.setKs(results);
            var version = null;
            for (var i = 0; i < mediaIdListArray.length; i++) {
                var result = client.media.get(onhandleSessionforFavouritesSuccess, mediaIdListArray[i], version);
            }
        }

        function handleSessionforRecentAdded(results) {
            client.setKs(results);

            var catfilter = new KalturaCategoryEntryFilter();
            catfilter.relatedObjects = new Array();
            catfilter.statusEqual = KalturaCategoryStatus.ACTIVE;
            //catfilter.orderBy = "+name";
            catfilter.orderBy = "-createdAt'";
            var pagercat = new KalturaFilterPager();
            pagercat.pageSize = parseInt(filterPageSize);
            var getAllCategories = client.category.listAction(onGetAllCategoriesSuccess, catfilter, pagercat); //7/26

        }

        function handleSessionPlayforRecentAdded(results) {
            client.setKs(results);
            //debugger;
            var id = "0_o3yswo4c";
            var detailed = null;
            var playlistContext = null;
            var filter = new KalturaMediaEntryFilterForPlaylist();
            //var filter.orderBy = "-recent";
            var pager = new KalturaFilterPager();
            var playListVideos = client.playlist.execute(cb, id, detailed, playlistContext, filter, pager);
        }

        function handleSessionforTopTenViewed(results) {
            //client.setKs(results);
            //var version = null;
            //for (var i = 0; i < mediaIdListArray.length; i++) {
            //    var result = client.media.get(onhandleSessionforTopTenViewedSuccess, mediaIdListArray[i], version);
            //}
            client.setKs(results);
            var filter = new KalturaCategoryEntryFilter();
            filter.orderBy = "-plays";
            filter.advancedSearch = new KalturaCategoryEntryAdvancedFilter();
            filter.mediaTypeEqual = KalturaMediaType.VIDEO;
            filter.statusIn = String(2);

            var pager = new KalturaFilterPager();
            //pager.pageSize = parseInt(filterPageSize);
            pager.pageSize = 10;
            var resultNew = client.media.listAction(onGetMediaInfoSuccess, filter, pager);
        }

        function handleMediaInfo(result) {
            element = document.getElementById("kaltura_media_by_category");
            element.innerHTML = '';
            document.getElementById("chkToggle").style.display = "block";
            var privateChannelName = '<%=ConfigurationManager.AppSettings["KalturaPrivateChannelFullName"].ToString() %>';
            var channelName = null;
            var searchString = null;

            for (var i = 0; i < result.objects.length; i++) {
                //channelName = result.objects[i].fullName;
                //searchString = channelName.indexOf(privateChannelName);
                //if (searchString != -1) {
                    var videoViews = result.objects[i].plays;
                    var timeDuration = msToTime(result.objects[i].msDuration);
                    element = document.getElementById("kaltura_media_by_category");
                    element.innerHTML += "<div class='constant picConstant'><div class='maindDivViewsAndLength'><div class='divViewsAndLengthOfVideo'><b><label class='views'><span>" + videoViews + "</span>  |  " + timeDuration + "</label></b></div></div><div class='divImageThumbnail'><a href='" + playVideoPageURL + "?mediaId=" + result.objects[i].id + "&categoryName=" + categoryName + "'><img alt='" + result.objects[i].name + "' src='" + result.objects[i].thumbnailUrl + "/width/400/'/></a></div><br/><div class='divNameOfVideo'><label class='labelNameOfVideo'>" + result.objects[i].name + "</label></div></div>";
                //}
            }
        }

        function handleFavouriteMediaInfo(result) {
            element = document.getElementById("kaltura_media_by_category");
            var videoViews = result.plays;
            var timeDuration = msToTime(result.msDuration);
            element = document.getElementById("kaltura_media_by_category");
            element.innerHTML += "<div class='constant picConstant'><div class='maindDivViewsAndLength'><div class='divViewsAndLengthOfVideo'><b><label class='views'><span>" + videoViews + "</span>  |  " + timeDuration + "</label></b></div></div><div class='divImageThumbnail'><a href='" + playVideoPageURL + "?mediaId=" + result.id + "&categoryName=" + categoryName + "'><img alt='" + result.name + "' src='" + result.thumbnailUrl + "/width/400/'/></a></div><br/><div class='divNameOfVideo'><label class='labelNameOfVideo'><i class='fa fa-trash' aria-hidden='true' data='" + result.id + "'></i> " + result.name + "</label></div></div>";
        }
        function handleRecentAddedMediaInfo(result) {
            element = document.getElementById("kaltura_media_by_category");

                var videoViews = resultNew.plays;
                var timeDuration = msToTime(resultNew.msDuration);
                element = document.getElementById("kaltura_media_by_category");
                element.innerHTML += "<div class='constant picConstant'><div class='maindDivViewsAndLength'><div class='divViewsAndLengthOfVideo'><b><label class='views'><span>" + videoViews + "</span>  |  " + timeDuration + "</label></b></div></div><div class='divImageThumbnail'><a href='" + playVideoPageURL + "?mediaId=" + resultNew.id + "&categoryName=" + categoryName + "'><img alt='" + resultNew.name + "' src='" + resultNew.thumbnailUrl + "/width/400/'/></a></div><br/><div class='divNameOfVideo'><label class='labelNameOfVideo'>" + resultNew.name + "</label></div></div>";
        }
        function handleTopTenViewedMediaInfo(result) {
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

        var onGetAllCategoriesSuccessNew = function (success, results) {
            if (!success)
                alert(results);

            if (results.code && results.message) {
                alert(results.message);
                return;
            }
            handleAllCategories(results);
        }

        function handleAllCategories(result) {
           
            var privateChannelName = '<%=ConfigurationManager.AppSettings["KalturaPrivateChannelFullName"].ToString() %>';
            var channelName = null;
            var searchString = null;
            privateCategoryIDs = new Array();
            privateCategoryNames = new Array();
            privateFullChannelID = new Array();
            flag = 0;
            for (var i = 0; i < result.objects.length; i++) {
                channelName = result.objects[i].fullName;
                searchString = channelName.indexOf(privateChannelName);
                //debugger;
                if (searchString != -1) {
                    if (result.objects[i].fullName != excludePublicCategory) {
                        privateCategoryIDs[flag] = result.objects[i].id;
                        privateFullChannelID[flag] = result.objects[i].fullIds;
                        privateCategoryNames[flag] = result.objects[i].fullName;
                        flag++;
                    }
                }
            }
            
            flag = 0;
            //debugger;
            var filter = new KalturaCategoryEntryFilter();
            filter.orderBy = "-recent";
            filter.advancedSearch = new KalturaCategoryEntryAdvancedFilter();
            filter.mediaTypeEqual = KalturaMediaType.VIDEO;
            filter.statusIn = String(2);
            //filter.categoryIdIn = "22187441";//String(privateCategoryIDs.toString());
            //filter.categoriesIdsMatchAnd = "22187441";
            filter.categoryFullIdsStartsWith = String(privateFullChannelID.toString());
            //filter.categoryIdIn = String(privateCategoryIDs.toString());

            var pager = new KalturaFilterPager();
            //pager.pageSize = parseInt(filterPageSize);
            pager.pageSize = 15;
            var resultNew = client.media.listAction(onGetMediaInfoSuccess, filter, pager);
        }

        function handleMediaBasedOnCategoryPrivate(result) {
            //for (var i = 0; i < result.objects.length; i++) {
            //    var index = privateCategoryIDs.indexOf(result.objects[i].categoryFullIds);
            //    element = document.getElementById('kaltura_media_all_categories');
            //    element.innerHTML += "<div class='grow pic'><div class='divHowToVideoCaptionPosition'><a href='" + redirectURL + "?id=" + privateCategoryIDs[index].split('>')[3] + "&categoryName=" + privateCategoryNames[index].split('>')[3] + "'><img alt='' src=" + serviceUrl + "/p/" + partnerId + "/sp/" + partnerId + "00/thumbnail/entry_id/" + result.objects[i].entryId + "/version/100001/width/500/'/></a></div><br/><div class='divHowToVideoCategoryName'><label>" + privateCategoryNames[index].split('>')[3] + "</label></div></div>";
            //    flag++;
            //}
        }


        function handleSubCategoryMediaInfo(result) {
            
            //debugger;
            if (categoryDepth === undefined && categoryDepth != 4) {
                var uniqueName = result.objects.uniqueObjects(["categoryFullIds"]);
                for (var i = 0; i < uniqueName.length; i++) {
                    var index = privateCategoryIDs.indexOf(uniqueName[i].categoryFullIds);
                    if (index != -1) {
                        //if (result.objects[i].categoryId == categoryId) {
                        element = document.getElementById('kaltura_media_all_subcategories');
                        element.innerHTML += "<div class='grow pic'><div class='divHowToVideoCaptionPosition'><a href='" + redirectURL + "?id=" + privateCategoryIDs[index].split('>')[4] + "&categoryName=" + privateCategoryNames[index].split('>')[4] + "&categoryDepth=4" + "'><img alt='' src=" + serviceUrl + "/p/" + partnerId + "/sp/" + partnerId + "00/thumbnail/entry_id/" + result.objects[i].entryId + "/version/100001/width/500/'/></a></div><br/><div class='divHowToVideoCategoryName'><label>" + privateCategoryNames[index].split('>')[4] + "</label></div></div>";
                        //}
                        //flag++;
                    }
                }
                //for (var i = 0; i < result.objects.length; i++) {
                //    categoryMediaEntryId = result.objects[i].entryId;
                //    //var index = privateCategoryIDs.indexOf(result.objects[i].categoryFullIds.substring(0, result.objects[i].categoryFullIds.length - String(result.objects[i].categoryId).length - 1));
                //    //var index = privateCategoryIDs.indexOf(result.objects[i].categoryFullIds);
                //    var index = privateCategoryIDs.indexOf(result.objects[i].categoryFullIds);
                    
                //    if (index != -1) {
                //        //if (result.objects[i].categoryId == categoryId) {
                //            element = document.getElementById('kaltura_media_all_subcategories');
                //            element.innerHTML += "<div class='grow pic'><div class='divHowToVideoCaptionPosition'><a href='" + redirectURL + "?id=" + privateCategoryIDs[index].split('>')[4] + "&categoryName=" + privateCategoryNames[index].split('>')[4] + "&categoryDepth=4" + "'><img alt='' src=" + serviceUrl + "/p/" + partnerId + "/sp/" + partnerId + "00/thumbnail/entry_id/" + result.objects[i].entryId + "/version/100001/width/500/'/></a></div><br/><div class='divHowToVideoCategoryName'><label>" + privateCategoryNames[index].split('>')[4] + "</label></div></div>";
                //        //}
                //        //flag++;
                //    }
                //    //element.innerHTML += "<div class='constant picConstant'><div class='maindDivViewsAndLength'><div class='divViewsAndLengthOfVideo'><b><label class='views'><span>" + videoViews + "</span>  |  " + timeDuration + "</label></b></div></div><div class='divImageThumbnail'><a href='" + playVideoPageURL + "?mediaId=" + result.objects[i].id + "&categoryName=" + categoryName + "'><img alt='" + result.objects[i].name + "' src='" + result.objects[i].thumbnailUrl + "/width/400/'/></a></div><br/><div class='divNameOfVideo'><label class='labelNameOfVideo'>" + result.objects[i].name + "</label></div></div>";

                //}
            }
        }

        Array.prototype.uniqueObjects = function (props) {
            function compare(a, b) {
                var prop;
                if (props) {
                    for (var j = 0; j < props.length; j++) {
                        prop = props[j];
                        if (a[prop] != b[prop]) {
                            return false;
                        }
                    }
                } else {
                    for (prop in a) {
                        if (a[prop] != b[prop]) {
                            return false;
                        }
                    }

                }
                return true;
            }
            return this.filter(function (item, index, list) {
                for (var i = 0; i < index; i++) {
                    if (compare(item, list[i])) {
                        return false;
                    }
                }
                return true;
            });
        };

        
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
            $('#chkSortOptions').change(function () {
                if (document.getElementById("chkSortOptions").checked == false) {
                    initialize_DisplayVideosByCategory('+name');
                }
                else {
                    initialize_DisplayVideosByCategory('-recent');
                }
            });
            var header = $(".modulecontent");
            header.removeClass("modulecontent");
            header.addClass("modulecontentForKaltura");
            initialize_DisplayVideosByCategory('-recent');
            $("#uploadUGC").hide();
            if (categoryId == 42109382)
            {
                $("#uploadUGC").show();
                var src = "/upload-video";

                $("#infoVideo").attr("href", src);
                
                //$(".cbVideoIframe").colorbox({ iframe: true, innerWidth: 600, innerHeight: 500 });
            }
            

            //o

        });

        window.onload = setTimeout(function () {
            var kSessionEnd = client.session.end(onKalturaSessionEndSuccess);
        }, 25000);

        var cb = function (success, results) {
            if (!success)
                alert(results);

            if (results.code && results.message) {
                alert(results.message);
                return;
            }

            handlePlayListMediaInfo(results);
        };

        var onGetKalturaSessionSuccessforPlaylistRecentAdded = function (success, results) {
            if (!success)
                alert(results);

            if (results.code && results.message) {
                alert(results.message);
                return;
            }
            handleSessionPlayforRecentAdded(results);
        };

        function handleSessionPlayforRecentAdded(results) {
            client.setKs(results);
            
            //debugger;
            var id = '<%=ConfigurationManager.AppSettings["KalturaPlayListId"].ToString() %>'; 
            var detailed = null;
            var playlistContext = null;
            var filter = new KalturaMediaEntryFilterForPlaylist();
            //var filter.orderBy = "-recent";
            var pager = new KalturaFilterPager();
            var playListVideos = client.playlist.execute(cb, id, detailed, playlistContext, filter, pager);
        }

        function handlePlayListMediaInfo(result) {
            element = document.getElementById("kaltura_media_by_category");
            element.innerHTML = '';
            for (var i = 0; i < result.length; i++) {
                var videoViews = result[i].plays;
                var timeDuration = msToTime(result[i].msDuration);
                element = document.getElementById("kaltura_media_by_category");
                element.innerHTML += "<div class='constant picConstant'><div class='maindDivViewsAndLength'><div class='divViewsAndLengthOfVideo'><b><label class='views'><span>" + videoViews + "</span>  |  " + timeDuration + "</label></b></div></div><div class='divImageThumbnail'><a href='" + playVideoPageURL + "?mediaId=" + result[i].id + "&categoryName=" + categoryName + "'><img alt='" + result[i].name + "' src='" + result[i].thumbnailUrl + "/width/400/'/></a></div><br/><div class='divNameOfVideo'><label class='labelNameOfVideo'>" + result[i].name + "</label></div></div>";
            }
        }
    </script>
</portal:OuterWrapperPanel>
