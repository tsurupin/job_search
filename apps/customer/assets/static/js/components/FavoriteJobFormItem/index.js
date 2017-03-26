import React, { PropTypes, Component } from 'react';
import { Link } from 'react-router';
import { SelectField } from 'components';
import { Wrapper, Form, Row } from './styles';

const propTypes = {
  jobId: PropTypes.number.isRequired,
  jobTitle: PropTypes.string.isRequired,
  area: PropTypes.string.isRequired,
  status: PropTypes.number,
  company: PropTypes.string.isRequired,
  remarks: PropTypes.string,
  index: PropTypes.number.isRequired,
  handleRemove: PropTypes.func.isRequired,
  handleUpdate: PropTypes.func.isRequired
};

const statusOptions = {"interesting": 0, "applying": 1};
const interestOptions = {"interesting": 1, "very interesting": 2, "my dream": 3}

class FavoriteJobFormItem extends Component {
  constructor(props) {
    super(props);

    const { interest, remarks, status } = props;

    this.state = {
      interest,
      remarks,
      status: status || 0,
      canSubmit: false
    };

    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleChange = this.handleChange.bind(this);
    this.handleRemove = this.handleRemove.bind(this);
  }

  handleSubmit(e) {
    e.preventDefault();
    this.props.handleUpdate(this.props.jobId, this.getUpdatedAttributes())
  }

  handleRemove() {
    this.props.handleRemove(this.props.jobId, this.props.index);
  }

  handleChange(key, value) {
    let updatedAttribute = {};
    updatedAttribute[key] = value;
    updatedAttribute['canSubmit'] = true;
    this.setState(updatedAttribute);
  }


  getUpdatedAttributes() {
    let attributes = {};
    if (this.props.interest !== this.state.interest) { attributes["interest"] = this.state.interest }
    if (this.props.status !== this.state.status) { attributes["status"] = this.state.status }
    if (this.props.remarks !== this.state.remarks) { attributes["remarks"] = this.state.remarks }

    return attributes;
  }

  labelId(name) {
    return `${name}_${this.props.jobId}`
  }

  render() {
    return (
      <Wrapper>
        <Form onSubmit={this.handleSubmit}>
          <Row size="3">
            <h3>{this.props.jobTitle}</h3>
            <p>{this.props.company}</p>
            <p>{this.props.area}</p>
          </Row>
          <Row size="1">
            <SelectField
              name="interest"
              tabIndex={2}
              value={parseInt(this.state.interest)}
              options={interestOptions}
              handleChange={this.handleChange}
            />
          </Row>
          <Row size="1">
            <SelectField
              name="status"
              tabIndex={3}
              value={parseInt(this.state.status)}
              options={statusOptions}
              handleChange={this.handleChange}
            />
          </Row>
          <Row size="3">
            <label htmlFor={this.labelId("remarks")} className="label">Remakrs</label>
            <textarea
              id={this.labelId("remarks")}
              name="remarks"
              defaultValue={this.props.remarks}
              rows={3}
              onBlur={(e) => this.handleChange(e.target.name, e.target.value)}
            />
          </Row>
          <Row size="2">
            <input
              type="submit"
              disabled={!this.state.canSubmit}
              tabIndex={4}
              value="Update"
            />
            <button type="button" onClick={this.handleRemove}>UnFavorite</button>
          </Row>
        </Form>
      </Wrapper>
    )
  }
}

FavoriteJobFormItem.propTypes = propTypes;
export default FavoriteJobFormItem;