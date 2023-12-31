import UIKit

final class MovieQuizViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    /*
     Создает кнопку “Нет” с использованием ленивой и приватной переменной. Она имеет круглые углы с радиусом 15, белый фон и черный текст. Кнопка также настроена на вызов метода noButtonClicked при нажатии на нее     */
    
    private lazy var noButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(noButtonClicked), for: .touchUpInside)
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .ypWhite
        $0.setAttributedTitle(NSAttributedString(string: "Нет", attributes: [
            .font: UIFont(name: "YSDisplay-Medium", size: 20)!,
            .foregroundColor: UIColor.ypBlack]), for: .normal)
        return $0
    }(UIButton(type: .system))
    
    private lazy var yesButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(yesButtonClicked), for: .touchUpInside)
        $0.setAttributedTitle(NSAttributedString(string: "Да", attributes: [
            .font: UIFont(name: "YSDisplay-Medium", size: 20)!,
            .foregroundColor: UIColor.ypBlack]), for: .normal)
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .ypWhite
        return $0
    }(UIButton(type: .system))
    
    private let questionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Вопрос:"
        $0.font = UIFont(name: "YSDisplay-Medium", size: 20)
        //        $0.font = .preferredFont(forTextStyle: .headline)
        $0.textColor = .ypWhite
        return $0
    }(UILabel(frame: .zero))
    
    private let indexLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "1/10"
        $0.font = UIFont(name: "YSDisplay-Medium", size: 20)
        //        $0.font = .preferredFont(forTextStyle: .headline)
        $0.textColor = .ypWhite
        return $0
    }(UILabel(frame: .zero))
    // бордюр
    private let previewImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.borderWidth = 8
        $0.layer.borderColor =
        UIColor.clear.cgColor // тут на превью рамка бесцветная
        $0.layer.cornerRadius = 20
        $0.layer.cornerCurve = .continuous
        $0.layer.allowsEdgeAntialiasing = true
        return $0
    }(UIImageView(image: UIImage(named: "preview")!))
    
    private let ratingLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Рейтинг этого фильма больше\u{00a0}чем 6?"
        
        $0.font = UIFont.init(name: "YSDisplay-Bold", size: 23)!
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.lineBreakStrategy = .init()
        $0.textColor = .ypWhite
        return $0
    }(UILabel(frame: .zero))
    
    private let buttonStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 20
        $0.alignment = .fill
        $0.distribution = .fillEqually
        return $0
    }(UIStackView(frame: .zero))
    
    private let labelStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 5, left: 0, bottom: 5, right: 0)
        
        return $0
    }(UIStackView(frame: .zero))
    
    private let mainStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        return $0
    }(UIStackView(frame: .zero))
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    
   
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    
    //    @IBOutlet weak var button: UIButton!
    // MARK: - Lifecycle
        //* 1.    viewDidLoad() - вызывается после того, как загрузился экран и все элементы интерфейса были загружены в память. Этот метод используется для инициализации свойств и установки начальных значений.
       // 2.    viewWillAppear(_ animated: Bool) - вызывается перед тем, как экран станет видимым. Этот метод используется для настройки элементов интерфейса перед отображением экрана.
        //3.    viewDidAppear(_ animated: Bool) - вызывается после того, как экран стал видимым. Этот метод используется для выполнения дополнительных действий, которые требуются после отображения экрана.
       // 4.    viewWillDisappear(_ animated: Bool) - вызывается перед тем, как экран перестанет быть видимым. Этот метод используется для сохранения изменений, внесенных на экране.
       // 5.    viewDidDisappear(_ animated: Bool) - вызывается после того, как экран перестал быть видимым. Этот метод используется для выполнения дополнительных действий после того, как экран был скрыт.
       // 6.    deinit() - вызывается перед тем, как экран будет уничтожен и освобожден из памяти. Этот метод используется для освобождения ресурсов и отмены подписок./

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContraints()
        view.backgroundColor = UIColor.ypBlack
    }
    
    // заполняем картинку, текст и счётчик данными
    private func show(quiz step: QuizStepViewModel) {
        indexLabel.text = step.questionNumber
        previewImageView.image = step.image
    }
    
    // здесь показываем результат прохождения квиза
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            
            self.correctAnswers = 0
            
            // заново показываем первый вопрос
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //* Конвертация — это преобразование. преобразование данных из одного формата в другой, то есть из QuizQuestion в QuizStepViewModel.
    //* В этом случае преобразуем данные, которые есть в модели вопроса, в те данные, которые необходимо показать на этапе квиза.
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(), // распаковываем картинку
            question: model.text, // берём текст вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)") // высчитываем номер вопроса
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers) из 10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
    }
    
    //  отображение красной или зелёной рамки, исходя из ответа:
    private func showAnswerResult(isCorrect: Bool) {if isCorrect {correctAnswers += 1}

        previewImageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return } // + неделя
            self.showNextQuestionOrResults()
            self.previewImageView.layer.borderColor = UIColor.clear.cgColor // исправление рамки
        }
    }

    }


extension MovieQuizViewController {
    private func setupContraints() {
        view.addSubview(mainStackView)
        
        buttonStackView.addArrangedSubview(noButton)
        buttonStackView.addArrangedSubview(yesButton)
        
        labelStackView.addArrangedSubview(questionLabel)
        labelStackView.addArrangedSubview(indexLabel)
        
        mainStackView.addArrangedSubview(labelStackView)
        mainStackView.addArrangedSubview(previewImageView)
        mainStackView.addArrangedSubview(ratingLabel)
        mainStackView.addArrangedSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 20),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor),
            
            buttonStackView.heightAnchor.constraint(equalToConstant: 60),
        ])
        // отступ 33 от слов "Рейтинг этого фильма ... до кнопок ,как указано в макете
        mainStackView.setCustomSpacing(33, after: ratingLabel)
        // отступ 33 от картинки до слов "Рейтинг этого фильма ... ,как указано в макете
        mainStackView.setCustomSpacing(33, after: previewImageView)
        // отступ 20 от слова вопрос до картинки ,как указано в макете
        mainStackView.setCustomSpacing(20, after: labelStackView)
        questionLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        indexLabel.setContentHuggingPriority(.required, for: .horizontal)
        previewImageView.setContentHuggingPriority(.fittingSizeLevel, for: .vertical) // Сопротивление расширения, тогда когда картинка маленькая и тогда это свойство сможет расширить нашу картинку
        
        previewImageView.setContentCompressionResistancePriority(.fittingSizeLevel, for: .vertical) // Сопротивление сжатию, когда картинка большая он сможет её сжать
    }
    
    @objc
    private func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @objc
    private func noButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}

struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
}

struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
}


/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
