<%@ Page Language="C#" AutoEventWireup="false" MasterPageFile="~/App_MasterPages/layout.Master" CodeBehind="Kaltura_DisplayVideosByCategory.aspx.cs" Inherits="mojoPortal.Web.Century21_Kaltura.Kaltura_DisplayVideosByCategory" %>

<asp:Content ContentPlaceHolderID="leftContent" ID="MPLeftPane" runat="server"></asp:Content>
<asp:Content ContentPlaceHolderID="mainContent" ID="MPContent" runat="server">
    <portal:OuterWrapperPanel ID="pnlOuterWrap" runat="server">
        <mp:CornerRounderTop ID="ctop1" runat="server" EnableViewState="false" />
        <portal:InnerWrapperPanel ID="pnlInnerWrap" runat="server" CssClass="panelwrapper htmlmodule">
            <portal:ModuleTitleControl ID="Title1" runat="server" EditUrl="/Modules/HtmlEdit.aspx" EnableViewState="false" />
            <portal:OuterBodyPanel ID="pnlOuterBody" runat="server">
                <portal:InnerBodyPanel ID="pnlInnerBody" runat="server" CssClass="modulecontent">
                    <div id="media">
                        <script type="text/javascript" src="../ClientScript/KalturaScripts/ox.ajast.js"></script>
                        <script type="text/javascript" src="../ClientScript/KalturaScripts/webtoolkit.md5.js"></script>
                        <script type="text/javascript" src="../ClientScript/KalturaScripts/KalturaClientBase.js"></script>
                        <script type="text/javascript" src="../ClientScript/KalturaScripts/KalturaTypes.js"></script>
                        <script type="text/javascript" src="../ClientScript/KalturaScripts/KalturaVO.js"></script>
                        <script type="text/javascript" src="../ClientScript/KalturaScripts/KalturaServices.js"></script>
                        <script type="text/javascript" src="../ClientScript/KalturaScripts/KalturaClient.js"></script>
                        <script type="text/javascript">
                            //Get querystring parameter
                            function getQueryStringParameter(param) {
                                var params = document.URL.split("?")[1].split("&");
                                for (var i = 0; i < params.length; i++) {
                                    var singleParam = params[i].split("=");
                                    if (singleParam[0] == param) {
                                        return singleParam[1];
                                    }
                                }
                            }

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

                            var onGetMediaBasedOnSubCategorySuccess = function (success, results) {
                                if (!success)
                                    alert(results);

                                if (results.code && results.message) {
                                    alert(results.message);
                                    return;
                                }
                                handleMediaBasedOnSubCategory(results);
                            }

                            //Read and initialize kaltura settings from web.config
                            var playerID = '<%=ConfigurationManager.AppSettings["KalturaPlayerID"].ToString() %>';
                            var kalturaPlayer = '<%=ConfigurationManager.AppSettings["kalturaPlayer"].ToString() %>';
                            var serviceUrl = '<%=ConfigurationManager.AppSettings["KalturaServiceUrl"].ToString() %>';
                            var secret = '<%=ConfigurationManager.AppSettings["KalturaAdminSecret"].ToString() %>';
                            var userId = '<%=ConfigurationManager.AppSettings["KalturaUserID"].ToString() %>';
                            var partnerId = '<%=ConfigurationManager.AppSettings["KalturaPartnerID"].ToString() %>';
                            var expiry = '<%=ConfigurationManager.AppSettings["KalturaSessionExpiry"].ToString() %>';
                            var type = KalturaSessionType.ADMIN;
                            var mediaPlayerId = '<%=ConfigurationManager.AppSettings["KalturaMediaPlayerID"].ToString() %>';
                            var flag = 0;
                            var element = null;
                            var categoryId = getQueryStringParameter('id');

                            //Get kaltura session
                            var config = new KalturaConfiguration(parseInt(partnerId));
                            config.serviceUrl = '<%=ConfigurationManager.AppSettings["KalturaConfigServiceURL"].ToString() %>';
                            var client = new KalturaClient(config);
                            var privileges = null;
                            //var sessionStartDate = new Date(2015, 4, 28, 0, 0, 0, 0);
                            //var sessionEndDate = new Date((sessionStartDate.getFullYear() + 10), (sessionStartDate.getMonth() - 1), (sessionStartDate.getDay() - 1), 0, 0, 0, 0);
                            //var todaysDate = new Date();
                            //if (todaysDate < sessionEndDate == true) {
                            //    var sessionKey = '<%=ConfigurationManager.AppSettings["KalturaSessionKey"].ToString() %>';
                            //    handleSession(sessionKey);
                            //}
                            //else {
                            //    var result = client.session.start(onGetKalturaSessionSuccess, secret, userId, type, parseInt(partnerId), parseInt(expiry), privileges);
                            //}
                            var result = client.session.start(onGetKalturaSessionSuccess, secret, userId, type, parseInt(partnerId), parseInt(expiry), privileges);

                            function handleSession(results) {
                                client.setKs(results);
                                //Get all the videos from particular channel sub category
                                var filter = new KalturaCategoryEntryFilter();
                                filter.relatedObjects = new Array();
                                filter.orderBy = "Most Recent";
                                filter.advancedSearch = new KalturaCategoryEntryAdvancedFilter();
                                filter.categoryFullIdsStartsWith = categoryId;
                                var pager = new KalturaFilterPager();
                                pager.relatedObjects = new Array();
                                pager.pageSize = 100;
                                var result = client.categoryEntry.listAction(onGetMediaBasedOnSubCategorySuccess, filter, pager);
                            }

                            function handleMediaInfo(result) {
                                var timeDuration = result.msDuration / 1000;
                                var timeDurationMinutes = timeDuration / 60;
                                var timeDurationSeconds = timeDuration % 60;
                                element = document.getElementById("kaltura_media_by_category");
                                element.innerHTML += "<tr><td style='text-align:center;'><a class='' href='" + serviceUrl + "/p/" + partnerId + "/sp/" + partnerId + "00/embedIframeJs/uiconf_id/" + mediaPlayerId + "/partner_id/" + partnerId + "?iframeembed=true&autoplay=true&&playerId=kaltura_player_" + kalturaPlayer + "&entry_id=" + result.id + "' width='400' height='330' allowfullscreen webkitallowfullscreen mozAllowFullScreen frameborder='0' target='_blank'><img class='' alt='" + result.name + "' src='" + result.thumbnailUrl + "/width/120/'/></a></td>" + "<td style='text-align:left;vertical-align:top'><a href='" + serviceUrl + "/p/" + partnerId + "/sp/" + partnerId + "00/embedIframeJs/uiconf_id/" + mediaPlayerId + "/partner_id/" + partnerId + "?iframeembed=true&autoplay=true&&playerId=kaltura_player_" + kalturaPlayer + "&entry_id=" + result.id + "' width='400' height='330' allowfullscreen webkitallowfullscreen mozAllowFullScreen frameborder='0' target='_blank'>" + result.name + "</a></td></tr>";
                            }

                            function handleMediaBasedOnSubCategory(result) {
                                var mediaEntryIdBasedOnCategory = new Array();
                                for (var i = 0; i < result.objects.length; i++) {
                                    mediaEntryIdBasedOnCategory[i] = result.objects[i].entryId;
                                    var media = client.media.get(onGetMediaInfoSuccess, result.objects[i].entryId, null);
                                }
                            }

                        </script>
                        <div style="width: 100%; height: auto;">
                            <table id="kaltura_media_by_category" style="width: 100%;">
                            </table>
                        </div>
                    </div>
                </portal:InnerBodyPanel>
                <portal:EmptyPanel ID="divFooter" runat="server" CssClass="modulefooter" SkinID="modulefooter"></portal:EmptyPanel>
            </portal:OuterBodyPanel>
            <portal:EmptyPanel ID="divCleared" runat="server" CssClass="cleared" SkinID="cleared"></portal:EmptyPanel>
        </portal:InnerWrapperPanel>
        <mp:CornerRounderBottom ID="cbottom1" runat="server" EnableViewState="false" />
    </portal:OuterWrapperPanel>
</asp:Content>
<asp:Content ContentPlaceHolderID="rightContent" ID="MPRightPane" runat="server"></asp:Content>
<asp:Content ContentPlaceHolderID="pageEditContent" ID="MPPageEdit" runat="server"></asp:Content>

