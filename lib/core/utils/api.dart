import 'package:flutter/material.dart';
import 'base_url.dart';

class Api {
  static Map routes() {
    return {
      'get_cities': 'basic-listing/cities',
      'get_breed': 'basic-listing/breeds',
      'get_breeder_chip_list': 'breeder/microchip/list',
      'get_examinations': 'basic-listing/examinations',
      'login': 'login',
      'forget_password': 'forgot/email',
      'detail_advert_view': 'f-end/advert/view/',
      'verify_email': 'email/resend',
      'delete_account': 'delete-account',
      'logout': 'logout',
      'create_stripe': 'breeder/on-boarding/create/account',
      'check_onBoard': 'breeder/on-boarding/check',

      //register_api--------------->>>
      'vet_signup': 'register/veterinarian',
      'charity_signup': 'register/charity',
      'breeder_signup': 'register/breeder',

      //breeder_api--------------->>>
      'get_breeder_view': 'breeder/profile/view',
      'update_license_info': 'breeder/profile/info/update',
      'breeder_microchip_summary': 'breeder/microchip/summary',
      'breeder_microchip_store': 'breeder/microchip/store',
      'breeder_recent': 'breeder/advert/recent',
      'breeder_listed_pets': 'breeder/advert/list',
      'breeder_sale': 'breeder/sale/list',
      'change_password': 'breeder/profile/change-password',
      'get_breed_edit_advert': 'breeder/advert/edit/',
      'get_advert_validate': 'breeder/advert/validate',
      'delete_advert': 'breeder/advert/delete/',
      'update_breeder_location': 'breeder/profile/update-location',
      'sale_commission_tax': 'breeder/sale/commission-and-tax',
      'update_puppy_chip_no': 'breeder/advert/',
      'breeder_list_messages': 'breeder/messages/adverts',
      'breeder_list_advert_messages':
      'breeder/messages/:advert_id/advert-buyers',
      'breeder_unread_messages_count': 'breeder/messages/unread-messages-count',
      'breeder_view_chat': 'breeder/messages/:chat_id/advert-conversation',
      'breeder_send_message': 'breeder/messages/:chat_id/send-message',

      //vet_api_routes----------->>>
      'vet_breeder_register': 'veterinarian/breeder/register',
      'vet_connected_breeder': 'veterinarian/connect/allConnects',
      'vet_view': 'veterinarian/profile/view',
      'vet_update_profile': 'veterinarian/profile/update',
      'vet_search_breeder': 'veterinarian/connect/search',
      'connect_breeder': 'veterinarian/connect/connectUser',
      'delete_connection': 'veterinarian/connect/removeConnect/',
      'get_adverts': 'veterinarian/connect/breeder/advert/',
      'get_sub_vet_list': 'veterinarian/sub-veterinarian/list',
      'add_vet_staff': 'veterinarian/sub-veterinarian/store',
      'get_edit_vet_staff': 'veterinarian/sub-veterinarian/edit/',
      'update_vet_staff_info': 'veterinarian/sub-veterinarian/update',
      'delete_vet_staff_info': 'veterinarian/sub-veterinarian/delete/',
      'get_advert_puppy': 'veterinarian/connect/breeder/advert/view/',
      'vet_change_password': 'veterinarian/profile/change-password',
      'update_vet_location': 'veterinarian/profile/update-location',

      //charity_api---------------------->>
      'get_charity_view': 'charity/profile/view',
      'charity_update_profile_info': 'charity/profile/update',
      'get_charity_recent': 'charity/advert/recent',
      'charity_listed_pets': 'charity/advert/list',
      'update_charity_password': 'charity/profile/change-password',
      'get_edit_charity_advert': 'charity/advert/edit/',
      'charity_delete_advert': 'charity/advert/delete/',
      'update_charity_location': 'charity/profile/update-location',
      'charity_list_messages': 'charity/messages/adverts',
      'charity_list_advert_messages':
      'charity/messages/:advert_id/advert-buyers',
      'charity_unread_messages_count': 'charity/messages/unread-messages-count',
      'charity_view_chat': 'charity/messages/:chat_id/advert-conversation',
      'charity_send_message': 'charity/messages/:chat_id/send-message',
    };
  }

  static String getUrl(key) {
    Map routes = Api.routes();
    return BaseUrl.getUrl() + routes[key];
  }
}
