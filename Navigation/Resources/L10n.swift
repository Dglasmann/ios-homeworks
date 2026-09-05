//
//  L10n.swift
//  Navigation
//
//  Created by Sasha Soldatov on 05.09.2026.
//  Централизованный доступ к локализованным строкам
//

import Foundation

enum L10n {

    // MARK: - Таб-бар

    enum TabBar {
        static let feed = NSLocalizedString("tabbar.feed", comment: "Вкладка «Лента»")
        static let profile = NSLocalizedString("tabbar.profile", comment: "Вкладка «Профиль»")
        static let media = NSLocalizedString("tabbar.media", comment: "Вкладка «Медиа»")
        static let favourites = NSLocalizedString("tabbar.favourites", comment: "Вкладка «Избранное»")
    }

    // MARK: - Авторизация

    enum Login {
        static let emailPlaceholder = NSLocalizedString("login.email.placeholder", comment: "Плейсхолдер поля email")
        static let passwordPlaceholder = NSLocalizedString("login.password.placeholder", comment: "Плейсхолдер поля пароля")
        static let logIn = NSLocalizedString("login.button.title", comment: "Кнопка входа")
        static let biometry = NSLocalizedString("login.biometry.button", comment: "Кнопка входа по биометрии")
        static let biometryReason = NSLocalizedString("login.biometry.reason", comment: "Причина запроса биометрии в системном диалоге")

        static let emptyEmail = NSLocalizedString("login.error.emptyEmail", comment: "Ошибка: не введён email")
        static let emptyPassword = NSLocalizedString("login.error.emptyPassword", comment: "Ошибка: не введён пароль")
        static let wrongPassword = NSLocalizedString("login.error.wrongPassword", comment: "Ошибка: неверный пароль")
        static let invalidCredentials = NSLocalizedString("login.error.invalidCredentials", comment: "Ошибка: неверные учётные данные")
        static let userNotFound = NSLocalizedString("login.error.userNotFound", comment: "Ошибка: пользователь не найден")

        static let biometryFailed = NSLocalizedString("login.error.biometryFailed", comment: "Общая ошибка биометрии")
        static let biometryNotEnrolled = NSLocalizedString("login.error.biometryNotEnrolled", comment: "Биометрия не настроена на устройстве")
        static let biometryNotAvailable = NSLocalizedString("login.error.biometryNotAvailable", comment: "Биометрия недоступна на устройстве")
        static let biometryLockout = NSLocalizedString("login.error.biometryLockout", comment: "Биометрия заблокирована после неудачных попыток")
        static let biometryCancelled = NSLocalizedString("login.error.biometryCancelled", comment: "Пользователь отменил авторизацию")
    }

    // MARK: - Профиль

    enum Profile {
        static let title = NSLocalizedString("profile.title", comment: "Заголовок экрана профиля")
        static let photos = NSLocalizedString("profile.photos.title", comment: "Заголовок секции фотографий")
        static let gallery = NSLocalizedString("profile.gallery.title", comment: "Заголовок экрана галереи")
        static let statusPlaceholder = NSLocalizedString("profile.status.placeholder", comment: "Плейсхолдер поля статуса")
        static let setStatus = NSLocalizedString("profile.status.button", comment: "Кнопка сохранения статуса")
        static let dragDropAuthor = NSLocalizedString("profile.dragdrop.author", comment: "Автор поста, созданного через drag&drop")

        /// Таймер сессии. `%@` — время в формате мм:сс.
        static func sessionTime(_ time: String) -> String {
            String(format: NSLocalizedString("profile.session.time", comment: "Время, проведённое на экране"), time)
        }

        /// Счётчик лайков. Формы множественного числа — в Localizable.stringsdict.
        /// `localizedStringWithFormat` обязателен: обычный `String(format:)`
        /// не применяет правила плюрализации текущей локали.
        static func likes(_ count: Int) -> String {
            String.localizedStringWithFormat(
                NSLocalizedString("post.likes", comment: "Счётчик лайков поста"),
                count
            )
        }

        /// Счётчик просмотров. Формы множественного числа — в Localizable.stringsdict.
        static func views(_ count: Int) -> String {
            String.localizedStringWithFormat(
                NSLocalizedString("post.views", comment: "Счётчик просмотров поста"),
                count
            )
        }
    }

    // MARK: - Лента

    enum Feed {
        static let title = NSLocalizedString("feed.title", comment: "Заголовок ленты")
        static let openFirstPost = NSLocalizedString("feed.openFirstPost", comment: "Кнопка открытия первого поста")
        static let openSecondPost = NSLocalizedString("feed.openSecondPost", comment: "Кнопка открытия второго поста")
        static let postTitle = NSLocalizedString("feed.post.title", comment: "Заголовок демо-поста")
        static let postDetails = NSLocalizedString("feed.post.details", comment: "Подпись на экране деталей поста")
        static let info = NSLocalizedString("feed.post.info", comment: "Кнопка перехода к информации")
        static let guessPlaceholder = NSLocalizedString("feed.guess.placeholder", comment: "Плейсхолдер поля секретного слова")
        static let check = NSLocalizedString("feed.check", comment: "Кнопка проверки слова")
        static let correct = NSLocalizedString("feed.result.correct", comment: "Слово угадано")
        static let incorrect = NSLocalizedString("feed.result.incorrect", comment: "Слово не угадано")
    }

    // MARK: - Информация (SWAPI)

    enum Info {
        static let showAlert = NSLocalizedString("info.showAlert", comment: "Кнопка показа алерта")
        static let alertTitle = NSLocalizedString("info.alert.title", comment: "Заголовок демонстрационного алерта")
        static let alertMessage = NSLocalizedString("info.alert.message", comment: "Текст демонстрационного алерта")
        static let loadingTitle = NSLocalizedString("info.loading.title", comment: "Заглушка при загрузке заголовка")
        static let loadingPeriod = NSLocalizedString("info.loading.period", comment: "Заглушка при загрузке периода обращения")

        /// Период обращения планеты. `%@` — значение из API.
        static func orbitalPeriod(_ value: String) -> String {
            String(format: NSLocalizedString("info.orbitalPeriod", comment: "Период обращения планеты"), value)
        }
    }

    // MARK: - Избранное

    enum Favourites {
        static let title = NSLocalizedString("favourites.title", comment: "Заголовок экрана избранного")
        static let filterTitle = NSLocalizedString("favourites.filter.title", comment: "Заголовок алерта фильтрации")
        static let filterMessage = NSLocalizedString("favourites.filter.message", comment: "Текст алерта фильтрации")
        static let filterPlaceholder = NSLocalizedString("favourites.filter.placeholder", comment: "Плейсхолдер поля автора")
        static let empty = NSLocalizedString("favourites.empty", comment: "Заглушка для пустого списка")
    }

    // MARK: - Медиа

    enum Media {
        static let title = NSLocalizedString("media.title", comment: "Заголовок раздела медиа")
        static let audioPlayer = NSLocalizedString("media.audioPlayer", comment: "Кнопка и заголовок аудиоплеера")
        static let videoPlayer = NSLocalizedString("media.videoPlayer", comment: "Кнопка видеоплеера")
        static let videoList = NSLocalizedString("media.videoList", comment: "Заголовок списка видео")
        static let recorder = NSLocalizedString("media.recorder", comment: "Кнопка и заголовок диктофона")

        static let play = NSLocalizedString("media.play", comment: "Кнопка воспроизведения")
        static let pause = NSLocalizedString("media.pause", comment: "Кнопка паузы")
        static let stop = NSLocalizedString("media.stop", comment: "Кнопка остановки")
        static let next = NSLocalizedString("media.next", comment: "Кнопка следующего трека")
        static let previous = NSLocalizedString("media.previous", comment: "Кнопка предыдущего трека")

        static let record = NSLocalizedString("media.record", comment: "Кнопка начала записи")
        static let stopRecording = NSLocalizedString("media.stopRecording", comment: "Кнопка остановки записи")
        static let playRecording = NSLocalizedString("media.playRecording", comment: "Кнопка воспроизведения записи")

        static let readyToRecord = NSLocalizedString("media.status.ready", comment: "Статус: готов к записи")
        static let recording = NSLocalizedString("media.status.recording", comment: "Статус: идёт запись")
        static let recordingSaved = NSLocalizedString("media.status.saved", comment: "Статус: запись сохранена")
        static let playingBack = NSLocalizedString("media.status.playing", comment: "Статус: воспроизведение записи")
        static let nothingToPlay = NSLocalizedString("media.status.nothingToPlay", comment: "Статус: записи ещё нет")

        static let microphoneGranted = NSLocalizedString("media.microphone.granted", comment: "Доступ к микрофону разрешён")
        static let microphoneDenied = NSLocalizedString("media.microphone.denied", comment: "Доступ к микрофону запрещён")
        static let recorderSetupFailed = NSLocalizedString("media.error.recorderSetup", comment: "Ошибка настройки диктофона")
        static let trackLoadFailed = NSLocalizedString("media.error.trackLoad", comment: "Ошибка загрузки трека")

        /// Название трека в плейлисте. `%d` — порядковый номер.
        static func trackName(_ number: Int) -> String {
            String(format: NSLocalizedString("media.track.name", comment: "Название трека с номером"), number)
        }

        /// Название видео в списке. `%d` — порядковый номер.
        static func videoName(_ number: Int) -> String {
            String(format: NSLocalizedString("media.video.name", comment: "Название видео с номером"), number)
        }
    }

    // MARK: - Уведомления

    enum Notifications {
        static let title = NSLocalizedString("notification.title", comment: "Заголовок локального уведомления")
        static let body = NSLocalizedString("notification.body", comment: "Текст локального уведомления")
        static let openAction = NSLocalizedString("notification.action.open", comment: "Кнопка действия в уведомлении")
    }

    // MARK: - Сеть

    enum Network {
        static let emptyData = NSLocalizedString("network.error.emptyData", comment: "Сервер вернул пустой ответ")
        static let decodingFailed = NSLocalizedString("network.error.decoding", comment: "Не удалось разобрать ответ сервера")
    }

    // MARK: - Общее

    enum Common {
        static let ok = NSLocalizedString("common.ok", comment: "Кнопка OK")
        static let cancel = NSLocalizedString("common.cancel", comment: "Кнопка отмены")
        static let apply = NSLocalizedString("common.apply", comment: "Кнопка применения")
        static let delete = NSLocalizedString("common.delete", comment: "Кнопка удаления")
        static let error = NSLocalizedString("common.error", comment: "Заголовок алерта об ошибке")
        static let loading = NSLocalizedString("common.loading", comment: "Индикатор загрузки")
    }
}
