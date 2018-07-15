<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Century21HomePage.ascx.cs" Inherits="mojoPortal.Web.Century21HomePage.Century21HomePage" %>
<%@ Register Src="~/CustomEventCalendar/HomePageEventsDisplay.ascx" TagPrefix="portal" TagName="HomePageEventsDisplay" %>
<%@ Register Src="~/Century21_Kaltura/Kaltura_HomePage.ascx" TagPrefix="Century21" TagName="KalturaVideoPlayer" %>


<script src="ClientScript/jqmojo/jquery.nivo.slider.pack3-2.js" type="text/javascript"></script>
<style>
    /*.clearfix .pvs. phm {
        display: none;
    }*/
    .divwh {
        width: 100%;
    }

    .divVideos {
        padding-top: 10px !important;
        width: 100% !important;
        display: flex;
    }

    .fullWidth tbody {
        display: flex;
    }

    .divHomePageVideos {
        height: 400px !important;
        width: 100% !important;
        padding-left: 1px !important;
    }

    .fullWidth tbody tr {
        width: 33%;
    }

        .fullWidth tbody tr td {
            width: 80%;
            display: block;
            margin-left: auto;
            margin-right: auto;
        }

            .fullWidth tbody tr td img {
                width: 100%;
            }

    /* The sticky class is added to the header with JS when it reaches its scroll position */
    .sticky {
        position: fixed;
        top: 0;
        width: 100%;
    }

        .sticky + .art-layout-wrapper {
            padding-top: 150px;
        }

    .art-layout-wrapper {
        margin: -35px auto !important;
    }

    .nivo-controlNav {
        display: none;
        z-index: 99 !important;
    }
</style>


<script>
    $(".art-sheet").attr("id", "myHeader");
    $(".art-nav").attr("id", "myHeader1");
    $(".art-layout-wrapper").attr("id", "content");

    $('<div/>', {
        id: 'headerNav',
        style: 'z-index:100'
    }).insertBefore('#content');

    $("#headerNav").append($("#myHeader"));
    $("#headerNav").append($("#myHeader1"));


    window.onscroll = function () { myFunction() };

    var header = document.getElementById("headerNav");

    var sticky = header.offsetTop;

    function myFunction() {
        if (window.pageYOffset > sticky) {
            header.classList.add("sticky");

        } else {
            header.classList.remove("sticky");

        }
    }
</script>




<script>
    //    (function (d, s, id) {
    //    var js, fjs = d.getElementsByTagName(s)[0];
    //    if (d.getElementById(id)) return;
    //    js = d.createElement(s); js.id = id;
    //    js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.3";
    //    fjs.parentNode.insertBefore(js, fjs);

    //}(document, 'script', 'facebook-jssdk'));

    function addCssFiles(url) {
        var head = document.getElementsByTagName('head')[0];
        var link = document.createElement('link');
        link.rel = 'stylesheet';
        link.type = 'text/css';
        link.href = url;
        link.media = 'all';
        head.appendChild(link);
    }
    $(document).ready(function () {
        loadconfigdata();

        //addCssFiles('/Data/Sites/1/skins/Theme_C21/fbstyle.css');
        $("#pageTitleId").hide();
        //        $(window).scrollTop(0);
        $('#slider').nivoSlider();
        //$(".cbVideoIframe").colorbox({ iframe: true, innerWidth: 425, innerHeight: 344 });
        if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
            var src = serviceUrl + "/p/" + partnerId + "/sp/" + partnerId + "00/embedIframeJs/uiconf_id/" + mediaPlayerId + "/partner_id/" + partnerId + "?iframeembed=true&playerId=divKaltura_play_Video&entry_id=0_5u6iyyxy&flashvars[autoPlay]=true";
            $("#infoVideo").attr("href", src);
            $("#infoVideo").click(function () {

                window.open($(this).attr('href'), "_blank");
                return false;
            });
        }
        else {
            getKatulraVideoURL();
            $(".cbVideoIframe").colorbox({ iframe: true, innerWidth: 600, innerHeight: 500 });
        }
    });
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
    var playHomePageVideosURL = null;
    var rootWebURL = null;
    var client = null;
    function loadconfigdata() {
        kalturaPlayer = '<%=ConfigurationManager.AppSettings["kalturaPlayer"].ToString() %>';
        serviceUrl = '<%=ConfigurationManager.AppSettings["KalturaServiceUrl"].ToString() %>';
        secret = '<%=ConfigurationManager.AppSettings["KalturaAdminSecret"].ToString() %>';
        userId = '<%=ConfigurationManager.AppSettings["KalturaUserID"].ToString() %>';
        partnerId = '<%=ConfigurationManager.AppSettings["KalturaPartnerID"].ToString() %>';
        expiry = '<%=ConfigurationManager.AppSettings["KalturaSessionExpiry"].ToString() %>';
        var type = KalturaSessionType.ADMIN;
        mediaPlayerId = '<%=ConfigurationManager.AppSettings["KalturaMediaPlayerIDforHomePage"].ToString() %>';
        playVideoPageURL = '<%=ConfigurationManager.AppSettings["KalturaPlayVideosPageURL"].ToString() %>';
        filterPageSize = '<%=ConfigurationManager.AppSettings["KalturaFilterPageSize"].ToString() %>';
        flag = 0;
        categoryId = '<%=ConfigurationManager.AppSettings["KalturaPublicChannelID"].ToString() %>';
        playHomePageVideosURL = '<%=ConfigurationManager.AppSettings["KalturaPlayHomePageVideosURL"].ToString() %>';
        rootWebURL = '<%= SiteUtils.GetNavigationSiteRoot() %>';
    }

    function getKatulraVideoURL() {

        var src = serviceUrl + "/p/" + partnerId + "/sp/" + partnerId + "00/embedIframeJs/uiconf_id/" + mediaPlayerId + "/partner_id/" + partnerId + "?iframeembed=true&playerId=divKaltura_play_Video&entry_id=0_5u6iyyxy&flashvars[autoPlay]=true";


        $("#infoVideo").attr("href", src);


    }
    window.onorientationchange = function () { window.location.reload(); };
</script>


<%--<portal:NivoSlider ID="NivoSlider1" runat="server" ImageFolder='~/Data/Sites/1/media/nivoimages' ImageWidth='100%' CssClass="nivocustomclass" Config="effect: 'fade'" />--%>
<%--="http://cdnapi.kaltura.com/p/1424291/sp/142429100/embedIframeJs/uiconf_id/28657531/partner_id/1424291?iframeembed=true&playerId=divKaltura_play_Video&entry_id=0_5u6iyyxy&flashvars[autoPlay]=true" >--%>
<div class="slider-wrapper theme-default" style="margin-top: -10px;">
    <div id="slider" class="nivoSlider">

        <a class="cbVideoIframe" id="infoVideo" href="#">

            <img src="Data/Sites/1/media/nivoimages/banner_image1.jpg" alt=""></a>
        <a class="cbVideoIframe" id="A1" href="http://www.theceshop.com/">
            <img src="Data/Sites/1/media/nivoimages/banner_image2.jpg" alt="">
        </a>
        <img src="Data/Sites/1/media/nivoimages/banner_image3.jpg" alt="">
        <img src="Data/Sites/1/media/nivoimages/banner_image4.jpg" alt="">
    </div>
</div>

<div class="homepagetablepadding theme-default" style="padding-top: 0px;">
    <div class="divnh">
        <div class="salesAssoheader">
            <div>Sales Assocoate Pathway</div>
        </div>
        <div style="width: 100%;">
            <div style="width: 100%; height: 190px; overflow: auto">
                <portal:ModuleWrapper ID="mdl119" runat="server" ConfigureModuleId="119" />
            </div>
        </div>
    </div>
    <div class="divnh">
        <div class="leaderShipheader">
            <div>Leadership Pathway</div>
        </div>
        <div style="width: 100%;">
            <div style="width: 100%; height: 190px; overflow: auto">
                <portal:ModuleWrapper ID="mdl120" runat="server" ConfigureModuleId="120" />
            </div>
        </div>
    </div>
    <div class="divnh" style="width: 34%;">
        <div class="watchheader">
            <div>Trainer Pathway</div>
        </div>
        <div style="width: 100%;">
            <div style="width: 100%; height: 200px; overflow: auto">
                <portal:ModuleWrapper ID="mdl121" runat="server" ConfigureModuleId="121" />
            </div>
        </div>
    </div>
</div>

<div class="homepagetablepadding" style="padding-top: 10px;">
    <div class="divnh" style="padding-bottom: 15px">
        <div class="watchheader">
            <%--<%= Resources.Resource.Century21HomePageEventNews %>--%>
            <div>Upcoming webinars</div>
        </div>
        <div style="width: 100%;">
            <div style="width: 100%; max-height: 200px; overflow-y: auto">
                <%--<portal:ModuleWrapper ID="ModuleWrapper1" runat="server" ConfigureModuleId="121" />--%>
                <asp:Panel ID="ListTemplate" runat="server" Style="padding-top: 10px">
                    <asp:Panel ID="pnlGridView" runat="server">
                        <asp:Repeater ID="rptSchedule" runat="server" ClientIDMode="Static">
                            <HeaderTemplate>
                                <div class="datagrid">
                                    <table>
                                        <thead>
                                        </thead>
                                        <tbody>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td class="right black" style="text-decoration: underline" id='<%# Eval("ScheduleId").ToString() %>'><a href="/classes"><%# Eval("Title").ToString()%> </a></td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                </tbody>
                    </table>
                    </div>
                            </FooterTemplate>
                        </asp:Repeater>
                    </asp:Panel>
                </asp:Panel>
            </div>
        </div>
    </div>

    <div class="divnh" style="padding-bottom: 15px">
        <div class="newsheader">
            <%--<%= Resources.Resource.Century21HomePageEventSocial %>--%>
            <div>C21 Workplace</div>
        </div>
        <div class="HomePageNewsFeed newseventscontent" style="width: 100%;">
            <div class="fb-page" data-href="https://www.facebook.com/century21" data-width="340" data-height="200" data-small-header="true" data-adapt-container-width="true" data-hide-cover="true" data-show-facepile="false" data-show-posts="true">
                <div class="fb-xfbml-parse-ignore">
                    <blockquote cite="https://www.facebook.com/century21">
                        <a href="https://www.facebook.com/century21">C21 University</a>
                    </blockquote>
                </div>
            </div>
        </div>
        <%--                
            <script>
                $(window).load(function () {

                    $(window).scrollTop(0);

                });
            </script>--%>
    </div>

    <div class="divnh" style="width: 34%; padding-bottom: 15px">
        <div class="socialeventsTabs">

            <ul class="tabs-menu">
                <li id="li1" class="current socicalfeed">
                    <div class="socialFeedDivTitle">C21 University News</div>
                </li>
            </ul>
            <div class="HoemPageEventsSocial" id="HMPgEvtScl">
                <div id="wrapper">
                    <div id="leftcolumn">
                        <div class="activeFBTabImageIndicator" id="FBTabActiveIndication">
                        </div>
                    </div>

                </div>
                <div style="clear: both;"></div>
                <div id="tabs-container" class="newseventscontent" style="width: 100%; float: left;">
                    <div class="tab" style="width: 100%;">
                        <div id="tab-1" class="tab-content" style="width: 100%;">

                            <div id="newsContent" class="" style="color: black; width: 100%; margin-top: 2px; overflow-y: scroll !important; height: 200px">

                                <portal:ModuleWrapper ID="mdl100" runat="server" ConfigureModuleId="100" />
                            </div>
                        </div>
                        <div id="tab-2" class="tab-content" style="width: 100%;">
                            <portal:HomePageEventsDisplay runat="server" ID="HomePageEventsDisplay" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>

<div class="divwh" style="padding-bottom: 15px">
    <div class="watchheader">
        <div><%= Resources.Resource.Century21HomePageEventWatch %></div>
    </div>
    <div class="HomePagetrData" style="width: 100%;">
        <div class="HomePageKalturaSection" style="width: 100%;">
            <div style="width: 100%;">
                <Century21:KalturaVideoPlayer runat="server" ID="C21KalturaPlayer" />
            </div>
        </div>

    </div>
</div>
