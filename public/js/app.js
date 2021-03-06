App = Ember.Application.create({rootElement: '#app'});

//////// Routes

App.Router = Ember.Router.extend({
  location: 'none'
});

App.Router.map(function() {
  this.resource('companies');
  this.resource('company', { path: '/company/:company_id' }, function() {
    this.resource('persons');
  });
});

App.LoadingRoute = Ember.Route.extend({
  renderTemplate: function() {
    this.render('loading', {
      outlet: 'loading',
      into: 'application'
    });
  }
});

App.IndexRoute = Ember.Route.extend({
  redirect: function() {
    this.transitionTo('companies');
  }
});

App.ApplicationRoute = Ember.Route.extend({
  actions: {
    openModal: function(modalName, model) {
      this.controllerFor(modalName).set('model', model);
      return this.render(modalName, {
        into: 'application',
        outlet: 'modal'
      });
    },

    closeModal: function() {
      return this.disconnectOutlet({
        outlet: 'modal',
        parentView: 'application'
      });
    }
  }
});

//////// Companies

App.CompaniesRoute = Ember.Route.extend({
  model: function() {
    return Ember.$.getJSON('/companies').then(function(data) {
      return data.companies;
    })
  }
});

App.CompaniesController = Ember.ArrayController.extend({
  actions: {
    createCompany: function () {
      var self = this;

      this.set('isLoading', true);

      var payload = this.getProperties('name', 'country', 'city', 'address', 'email', 'phone')
      Ember.$.post('/companies', payload).then(function(data) {
        if (data.success) {
          self.insertAt(0, data.company);

          $('#new-company-dialog').modal('hide');

          self.set('name', '');
          self.set('country', '');
          self.set('city', '');
          self.set('address', '');
          self.set('email', '');
          self.set('phone', '');
        } else {
          alert(data.message);
        }

        self.set('isLoading', false);
      })
    },
    updateSelectedRow: function(row) {
      var lastSelected = this.get('selectedRow');

      if (lastSelected === row) return;

      if (lastSelected && !lastSelected.isDestroyed) {
        lastSelected.set('selected', false);
      }

      row.set('selected', true);
      this.set('selectedRow', row);
    },
    deleteCompany: function(company) {
      this.removeObject(company);
    }
  }
})

App.CompanyController = Ember.ObjectController.extend({
  actions: {
    editCompany: function () {
      var copyModel = Ember.Object.create(this.getProperties('id', 'name', 'country', 'city', 'address', 'email', 'phone'));
      copyModel.set('originalController', this);
      this.send("openModal", "edit-company", copyModel);
    },
    destroyCompany: function () {
      var company = this.get('model');
      var self = this;

      this.set('isDeleting', true);
      Ember.$.post('/companies/' + company.id, {_method: 'delete'}).then(function(data) {
        if (data.success) {
          self.send('deleteCompany', company);
        } else {
          alert(data.message);
        }

        self.set('isDeleting', false);
      })
    },
    editPersons: function() {
      var company = this.get('model');
      this.transitionToRoute('persons', company);
    },
    selectRow: function() {
      this.send('updateSelectedRow', this);
    }
  }
});

App.EditCompanyController = Ember.ObjectController.extend({
  actions: {
    update: function(callback) {
      var company = this.get('model');
      var self = this;

      var payload = this.getProperties('name', 'country', 'city', 'address', 'email', 'phone');
      payload['_method'] = 'put';

      this.set('isLoading', true);
      Ember.$.post('/companies/' + company.id, payload).then(function(data) {
        if (data.success) {
          var control = company.get('originalController');
          control.setProperties(data.company);

          callback();
        } else {
          alert(data.message);
        }

        self.set('isLoading', false);
      })

    }
  }
});

App.EditCompanyView = Ember.View.extend({
  templateName: "edit-company",
  didInsertElement: function() {
    this.$('.modal').modal('show');
    this.$('.modal').one("hidden.bs.modal", this._dialogClose.bind(this));
    this.$('.modal .update').click(this._updateClicked.bind(this));
  },
  _dialogClose: function() {
    if (!this.isDestroyed) {
      this.destroy();
    }
    return this.send('closeModal');
  },
  _updateClicked: function() {
    var self = this;
    this.get('controller').send('update', function() {
      self.$('.modal').modal('hide');
      self.send('closeModal');
    });
  }
})

//////// Persons

App.PersonsRoute = Ember.Route.extend({
  model: function(params) {
    var company = this.modelFor('company');
    this.set('company', company);
    return Ember.$.getJSON('/persons?company_id=' + company.id).then(function(data) {
      return data.persons;
    })
  },
  setupController: function(controller, model) {
    controller.set('company', this.company);
    controller.set('model', model);
  }
});


App.PersonsController = Ember.ArrayController.extend({
  actions: {
    createPerson: function () {
      var self = this;

      this.set('isLoading', true);

      var payload = {name: this.get('newName'), company_id: this.company.id}
      Ember.$.post('/persons', payload).then(function(data) {
        if (data.success) {
          self.insertAt(0, data.person);

          self.set('newName', '');
        } else {
          alert(data.message);
        }

        self.set('isLoading', false);
      })
    },
    deletePerson: function(person) {
      this.removeObject(person);
    }
  }
})

App.PersonController = Ember.ObjectController.extend({
  hasFile: function() {
    var model = this.get('model');
    return model.passport_file_name && /\w+/.test(model.passport_file_name);
  }.property('model.passport_file_name'),

  actions: {
    editPerson: function () {
      this.set('isEditing', true)
    },
    updatePerson: function() {
      var person = this.get('model');
      var self = this;

      this.set('isUpdating', true);

      Ember.$.post('/persons/' + person.id, {_method: 'put', name: person.name}).then(function(data) {
        if (data.success) {
          self.set('isEditing', false);
        } else {
          alert(data.message);
        }

        self.set('isUpdating', false);
      })
    },
    destroyPerson: function () {
      var person = this.get('model');
      var self = this;

      this.set('isDeleting', true);
      Ember.$.post('/persons/' + person.id, {_method: 'delete'}).then(function(data) {
        if (data.success) {
          self.send('deletePerson', person);
        } else {
          alert(data.message);
        }

        self.set('isDeleting', false);
      })
    },
    fileUploadSuccess: function(url) {
      var person = this.get('model');
      var self = this;
      Ember.$.post('/persons/' + person.id + '/attach', {_method: 'put', s3_url: url}).then(function(data) {
        if (data.success) {
          self.setProperties(data.person);
        } else {
          alert(data.message);
        }
      })
    },
    detachFile: function(callback) {
      var person = this.get('model');
      var self = this;

      this.set('isDetaching', true);
      Ember.$.post('/persons/' + person.id + '/detach', {_method: 'delete'}).then(function(data) {
        if (data.success) {
          self.setProperties(data.person);
        } else {
          alert(data.message);
        }
        self.set('isDetaching', false);
      })
    }
  }
});

App.EditPersonView = Ember.TextField.extend({
  didInsertElement: function () {
    this.$().focus();
  }
});

App.FileUploadView = Ember.View.extend({
  templateName: 'file',
  didInsertElement: function() {
    this.$('form').fileupload({
      add: this.fileAdded.bind(this),
      done: this.done.bind(this),
      progress: this.progress.bind(this),
      fail: this.fail.bind(this)
    });
  },
  fileAdded: function(e, data) {
    var self = this;
    var controller = this.get('controller');
    $.post('/persons/' + controller.get('id') + '/policy', function(res) {
      self.$('form').attr('action', res.action)
      self.$('form').find('input[name=AWSAccessKeyId]').val(res.s3_id);
      self.$('form').find('input[name=key]').val(res.key);
      self.$('form').find('input[name=policy]').val(res.policy);
      self.$('form').find('input[name=signature]').val(res.signature);

      self.$('form').find('.progress').removeClass('hide');

      data.submit();
    });
  },
  done: function(e, data) {
    if(data.textStatus == "success") {
      this.get('controller').send('fileUploadSuccess', data.files[0].name);
    }
    this.$(".progress-bar").css({width: '0%'});
    this.$('form').find('.progress').addClass('hide');
  },
  progress: function(e, data) {
    progress = parseInt(data.loaded / data.total * 100, 10);
    this.$(".progress-bar").css({width: progress + '%'});
  },
  fail: function(e, data) {
    alert("Upload failed.");
    this.done();
  }
});

Ember.Handlebars.helper('edit-person', App.EditPersonView);