/* eslint-disable @lwc/lwc/no-document-query */
/* eslint-disable no-console */
import {
    LightningElement,
    wire,
    track,
    api
} from 'lwc';
import {
    loadScript,
    loadStyle
} from 'lightning/platformResourceLoader';
import {
    getRecord
} from 'lightning/uiRecordApi';
//import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// import {
//     isMobile
// } from 'c/portalUtils';

// import getWorkOrdersByAccountId from '@salesforce/apex/WorkOrderSelector.getWorkOrdersByAccountId';
// import getWorkOrdersByUserId from '@salesforce/apex/PortalCalendarioController.getWorkOrdersByUserId';
// import checkPermissionByDeveloperName from '@salesforce/apex/FeatureManagementService.checkPermissionByDeveloperName';
// import retrieveEvents from '@salesforce/apex/PortalCalendarioController.getEvents';
// import getEventsEmp from '@salesforce/apex/PortalCalendarioController.getEventsEmp';
// import getAssuntosPermitidos from '@salesforce/apex/PortalCalendarioController.getAssuntosPermitidos';

import UTIL_PORTAL from '@salesforce/resourceUrl/PortalCury';
import Id from '@salesforce/user/Id';
// import getUserFromUserInfo from '@salesforce/apex/PortalCalendarioController.getUserFromUserInfo';

const FIELDS = [
    'User.AccountId',
    'User.Account.AtivoSelecionado__r.Empreendimento__c',
];

export default class PortalCalendario extends LightningElement {
    @api isCommunity;

    @track calendarInitialized = false;
    reload = true;

    @track loaded = true;
    @track events = new Array();
    @track jsonEvents = new Array();
    @track accountId = '';
    @track hasPermission = true;
    @track user = null;
    @track assuntosPermitidos = new Array();

    @api urlVideo;
    @api width;
    @api height;

    @api urlVideo2;
    @api width2;
    @api height2;
/* 
    @wire(getAssuntosPermitidos)
    wiredAssuntosPermitidos(value) {
        console.log('wiredAssuntosPermitidos');

        if (value.data) {
            let assPermitidos = new Array();

            if (Array.isArray(value.data)) {
                value.data.forEach(data => {
                    assPermitidos.push(data.MasterLabel);
                });
            }

            this.assuntosPermitidos = assPermitidos;
        }
    }
 */
    /*wire(getRecord, { recordId: Id, fields: FIELDS })
      wiredCase(value) {
        console.log('wiredCase');
          if(this.reload){
            this.hasCalendarPermission();
            if(this.hasPermission === false){
                this.reload = false;
                this.calendarInitialized = true;
            }
          }

          this.user = value;
          if (value.data && this.reload) {
              this.accountId = this.user.data.fields.AccountId.value;
              this.emp = value.data.fields.Account.value.fields.AtivoSelecionado__r.value.fields.Empreendimento__c.value;
            //  console.log('accountId');
            //  console.log(this.accountId);
              this.getEvents();
              this.reload = false;
          }
      }*/

    getUserInfo() {
        if (this.reload) {
            this.hasCalendarPermission();
            if (this.hasPermission === false) {
                this.reload = false;
                this.calendarInitialized = true;
            }
        }
        this.loaded = true;
        console.log('getUserInfo');
        getUserFromUserInfo().then(result => {
            console.log('this.user');
            console.log(result);
            console.log(result.Id);
            console.log(result.SmallPhotoUrl);
            if (result !== undefined && this.reload) {
                this.accountId = (result.AccountId !== undefined) ? result.AccountId : '';

                if (this.accountId != '' && result.Account.AtivoSelecionado__c !== undefined) {
                    if (result.Account.AtivoSelecionado__r.Empreendimento__c !== undefined) {
                        this.emp = result.Account.AtivoSelecionado__r.Empreendimento__c;
                    }
                }
                this.loaded = false;
                this.getEvents();
                this.reload = false;
            }
        }).catch(error => {
            /* eslint-disable no-console */
            // console.log('hasCalendarPermission');
            console.error(JSON.stringify(error));
            this.loaded = false;
        });
    }
    connectedCallback() {
        console.log('portalCalendario:connectedCallback');
        this.getUserInfo();
    }

    renderedCallback() {
        this.forceCalendar();
        this.adjustMobile();
    }

    hasCalendarPermission() {
        this.loaded = true;
        checkPermissionByDeveloperName({
            developerName: 'PermissaoCalendario'
        }).then(result => {
            console.log('hasCalendarPermission' + result);
            this.hasPermission = result;
            this.loaded = false;
        }).catch(error => {
            /* eslint-disable no-console */
            // console.log('hasCalendarPermission');
            console.error(JSON.stringify(error));
            this.loaded = false;
        });
    }

    getEvents() {
        //console.log('getEvents');
        console.log('this.accountId', this.accountId);
        console.log('Id', Id);
        if (this.accountId !== '' && this.accountId !== null && this.accountId !== undefined) {
            console.log('getWorkOrdersByAccountId');
            console.log(this.accountId);
            getWorkOrdersByAccountId({
                accountId: this.accountId
            }).then(result => {
                console.log(result);
                if (result.length > 0) {
                    this.calendarInitialized = false;
                    this.jsonEvents = new Array();
                    this.events = new Array();
                    for (let i = 0; i < result.length; i++) {
                        if (result[i].Status !== 'Cancelado' && result[i].Status !== 'Concluído') {
                            this.events.push({
                                id: result[i].Id,
                                title: result[i].Subject + ': ' + result[i].WorkOrderNumber,
                                start: result[i].StartDate,
                                end: result[i].EndDate,
                                color: '#50e3c2'
                            });
                        }
                    }
                    this.jsonEvents = this.events;

                    // this.forceCalendar();          
                }
                this.retrieveMyEventsOfWorld();
            }).catch(error => {
                // console.error('getEvents error');
                console.error(JSON.stringify(error));
            });
        } else if ((this.accountId === undefined || this.accountId === null || this.accountId === '') && Id !== null && Id !== '') {
            console.log('getWorkOrdersByUserId');
            getWorkOrdersByUserId({
                userId: Id
            }).then(result => {
                // console.log(result);
                if (result.length > 0) {
                    this.calendarInitialized = false;
                    this.jsonEvents = new Array();
                    this.events = new Array();
                    for (let i = 0; i < result.length; i++) {
                        let actualEnd = result[i].CompromissoServico__r.ActualStartTime;
                        let end = result[i].EndDate;
                        console.log(result[i].WorkOrderNumber);
                        console.log(actualEnd);
                        console.log(end);
                        if (result[i].Status !== 'Cancelado' && result[i].Status !== 'Concluído' && (!actualEnd || (actualEnd && actualEnd >= end))) {  //nao mostrar as antecipadas
                            this.events.push({
                                id: result[i].Id,
                                title: result[i].WorkOrderNumber + ': ' + result[i].Subject,
                                start: result[i].StartDate,
                                end: result[i].EndDate,
                                color: '#50e3c2'
                            });
                        }
                    }
                    this.jsonEvents = this.events;

                    // this.forceCalendar();
                }
                this.retrieveMyEventsOfWorld();
            }).catch(error => {
                console.error('getEvents error');
                console.error(JSON.stringify(error));
            });
        }
    }

    retrieveMyEventsOfWorld() {
        retrieveEvents({
            accountId: this.accountId
        }).then(result => {
            console.log('retrieveEvents');
            console.log(result);
            this.compromissos = {};
            let events = new Array();
            for (let i = 0; i < result.length; i++) {
                if (this.assuntosPermitidos.includes(result[i].Subject)) {
                    events.push({
                        id: result[i].Id,
                        title: result[i].Subject,
                        start: result[i].StartDateTime,
                        end: result[i].EndDateTime,
                        color: '#eb7092' /*: '#50e3c2'*/
                    });
                    this.compromissos = {
                        ...this.compromissos,
                        [result[i].Id]: result[i]
                    };
                }
            }
            console.log('%cretrieveCompromissos', 'color: deeppink;');
            console.log(this.compromissos);

            this.jsonEvents = this.jsonEvents.concat(events);

            this.retrieveMyEventsOfWorldEmp()
        }).catch(error => {
            /* eslint-disable no-console */
            // console.log('hasCalendarPermission');
            console.error(JSON.stringify(error));
            this.loaded = false;
        });
    }

    retrieveMyEventsOfWorldEmp() {
        getEventsEmp({
            emp: this.emp
        }).then(result => {
            console.log(`%c${this.emp}`, 'color: blue;');
            console.log('%cretrieveEvents', 'color: blue;');
            console.log(result);
            console.log(this.emp);
            // this.compromissos = {};
            let events = new Array();
            for (let i = 0; i < result.length; i++) {
                if (this.assuntosPermitidos.includes(result[i].Subject)) {
                    events.push({
                        id: result[i].Id,
                        title: result[i].Subject,
                        start: result[i].StartDateTime,
                        end: result[i].EndDateTime,
                        color: '#50e3c1'
                    });
                    this.compromissos = {
                        ...this.compromissos,
                        [result[i].Id]: result[i]
                    };
                }

            }

            this.jsonEvents = this.jsonEvents.concat(events);

            this.initCalendar();
        }).catch(error => {
            /* eslint-disable no-console */
            // console.log('hasCalendarPermission');
            console.error(JSON.stringify(error));
            this.loaded = false;
        });
    }

    forceCalendar() {
        this.loaded = false;

        if (this.calendarInitialized) {
            return;
        }

        console.log('Promise.all');

        Promise.all([
                // load FullCalendar core 
                loadScript(this, UTIL_PORTAL + '/library/fullcalendar/core/main.js'),
                loadScript(this, UTIL_PORTAL + '/library/fullcalendar/core/locales-all.js'),
                loadStyle(this, UTIL_PORTAL + '/library/fullcalendar/core/main.css'),
            ])
            .then(() => {
                console.log('Promise.all1: success');
                Promise.all([
                        // load other plugins in a new promise
                        loadScript(this, UTIL_PORTAL + '/library/fullcalendar/interaction/main.js'),
                        loadScript(this, UTIL_PORTAL + '/library/fullcalendar/daygrid/main.js'),
                        loadStyle(this, UTIL_PORTAL + '/library/fullcalendar/daygrid/main.css'),
                    ])
                    .then(() => {
                        console.log('Promise.all2: success');
                        window.console.log('forceCalendar loaded');
                        this.calendarInitialized = true;
                        this.initCalendar();
                    })
                    .catch(error => {
                        console.log('Promise.all2: error');
                        console.log(JSON.stringify(error));
                        window.console.log('forceCalendar error' + JSON.stringify(error));
                        this.calendarInitialized = false;
                    });

            })
            .catch(error => {
                console.log('Promise.all1: error');
                console.log(JSON.stringify(error));
                this.calendarInitialized = false;
            });
    }

    get existEvents() {
        return this.jsonEvents.length > 0 || this.isCommunity;
    }

    initCalendar() {
        console.log('initCalendar...');
        if (!this.calendarInitialized) {
            console.log('call forceCalendar');
            this.forceCalendar();
            return;
        }

        if (this.jsonEvents.length == 0 && !this.isCommunity) {
            console.log('no events');
            return;
        }

        let today = new Date();
        let dd = today.getDate();
        let mm = today.getMonth() + 1; //As January is 0.
        let yy = today.getFullYear();

        if (dd < 10) dd = '0' + dd;
        if (mm < 10) mm = '0' + mm;

        let calendarEl = this.template.querySelector('.calendar');
        let template = this.template;

        // console.log('this.jsonEvents');
        // console.log(this.jsonEvents);
        let events = this.jsonEvents;
        let compromissos = this.compromissos;

        // eslint-disable-next-line no-undef
        const calendar = new FullCalendar.Calendar(calendarEl, {
            plugins: ['interaction', 'dayGrid'],
            defaultDate: yy + '-' + mm + '-' + dd,
            editable: true,
            eventLimit: true, // allow "more" link when too many events
            locale: 'pt-br',
            timeZone: 'local',
            events: this.jsonEvents,
            eventClick: function(info) {
                console.log('Event: ' + info.event.title);
                console.log('Id: ' + info.event.id);
                // eslint-disable-next-line no-new-object

                if (info.event.backgroundColor != '#eb7092' && info.event.backgroundColor != '#50e3c1') {
                    let modal = template.querySelector('c-portal-modal-create-work-order');
                    let obj = new Object();
                    obj.workOrderId = info.event.id;
                    modal.show(obj, events);
                } else {
                    let modal = template.querySelector('c-portal-modal-compromisso');
                    modal.setValues(info.event.id, compromissos)
                    modal.showHide();
                }
            },
            eventMouseEnter: function(info) {

                if (info.event.backgroundColor == '#eb7092') {
                    info.el.style.background = '#90387a';
                    info.el.style.borderColor = '#90387a';
                } else {
                    info.el.style.background = '#33947e';
                    info.el.style.borderColor = '#33947e';
                }

            },
            eventMouseLeave: function(info) {
                if (info.event.backgroundColor == '#eb7092') {
                    info.el.style.background = '#eb7092'; //Rose
                    info.el.style.borderColor = '#eb7092';
                } else {
                    info.el.style.background = '#50e3c2'; //lue
                    info.el.style.borderColor = '#50e3c2';
                }
            }
        });

        calendar.render();

        //Excluindo se renderizou mais de uma vez o calendario
        let headers = document.getElementsByClassName('fc-toolbar fc-header-toolbar');
        if (headers.length > 1) {
            for (let i = 1; i < headers.length; i++) {
                headers[i].remove();
            }
        }

        let containers = document.getElementsByClassName('fc-view-container');
        if (containers.length > 1) {
            for (let i = 1; i < containers.length; i++) {
                containers[i].remove();
            }
        }

        this.adjustMobile();
    }

    refreshCalendar() {
        let calendarEl = this.template.querySelector('div');
        calendarEl.refetchEvents();
    }

    openModal() {
        const modal = this.template.querySelector('c-portal-modal-create-work-order');
        modal.show();
    }

    get displayCommunity() {
        return this.isCommunity ? 'display:flex;' : 'display:none;';
    }

    get sizeCommunity() {
        return this.isCommunity && !isMobile() ? 'slds-col slds-size_1-of-2' : 'slds-col slds-size_1-of-1';
    }

    get adjustMain() {
        return isMobile() ? 'slds-grid slds-grid_align-space main-content-mobile' : 'slds-grid slds-grid_align-space main-content-main';
    }

    adjustMobile() {
        if (isMobile()) {
            const calendar = this.template.querySelector('.calendar.fc.fc-ltr.fc-unthemed')
            calendar.style.width = '100%';

            const d1 = this.template.querySelector('.fc-toolbar.fc-header-toolbar');
            d1.style.fontSize = '10px';

            const d2 = this.template.querySelector('.fc-scroller.fc-day-grid-container');
            d2.style.height = '100%';


        }
    }
}