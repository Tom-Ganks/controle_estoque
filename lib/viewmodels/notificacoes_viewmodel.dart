import '../models/notificacoes_model.dart';
import '../repositories/notificacao_repository.dart';

class NotificacoesViewModel {
  final NotificacoesRepository _repository = NotificacoesRepository();
  List<Notificacao> notificacoes = [];
  List<Notificacao> unreadNotificacoes = [];

  Future<bool> deleteAllNotificacoes() async {
    try {
      await _repository.deleteAll();
      await fetchAllNotificacoes();
      await fetchUnreadNotificacoes();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> fetchAllNotificacoes() async {
    notificacoes = await _repository.fetchAll();
  }

  Future<void> fetchUnreadNotificacoes() async {
    unreadNotificacoes = await _repository.fetchUnread();
  }

  Future<List<Notificacao>> fetchByUser(String solicitanteNome) async {
    return await _repository.fetchByUser(solicitanteNome);
  }

  Future<List<Notificacao>> fetchByMovimentacao(int idMovimentacao) async {
    return await _repository.fetchByMovimentacao(idMovimentacao);
  }

  Future<bool> insertNotificacao(Notificacao notificacao) async {
    try {
      await _repository.insert(notificacao);
      await fetchAllNotificacoes(); // Refresh the list
      await fetchUnreadNotificacoes(); // Refresh unread list
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> markAsRead(int id) async {
    try {
      await _repository.markAsRead(id);
      await fetchAllNotificacoes(); // Refresh the list
      await fetchUnreadNotificacoes(); // Refresh unread list
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> markAllAsRead() async {
    try {
      await _repository.markAllAsRead();
      await fetchAllNotificacoes(); // Refresh the list
      await fetchUnreadNotificacoes(); // Refresh unread list
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteNotificacao(int id) async {
    try {
      await _repository.delete(id);
      await fetchAllNotificacoes(); // Refresh the list
      await fetchUnreadNotificacoes(); // Refresh unread list
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<int> getUnreadCount() async {
    return await _repository.getUnreadCount();
  }
}
