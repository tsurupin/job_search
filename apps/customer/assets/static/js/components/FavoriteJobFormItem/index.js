import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { Link } from 'react-router';
import { SelectField, Textarea } from 'components';
import MdLocationCity from 'react-icons/lib/md/location-city';
import MdLocationOn from 'react-icons/lib/md/location-on';
import MdSave from 'react-icons/lib/md/save';

import {
  Wrapper,
  Icon,
  CompanyWrapper,
  CompanyInfo,
  TitleLink,
  Info,
  Form,
  Row,
  UpdateButton,
} from './styles';
import GoStar from 'react-icons/lib/go/star';

const propTypes = {
  jobId: PropTypes.number.isRequired,
  jobTitle: PropTypes.string.isRequired,
  area: PropTypes.string.isRequired,
  status: PropTypes.number,
  company: PropTypes.string.isRequired,
  remarks: PropTypes.string,
  index: PropTypes.number.isRequired,
  handleRemove: PropTypes.func.isRequired,
  handleUpdate: PropTypes.func.isRequired,
};

const statusOptions = { Interesting: 0, Applying: 1, 'Phone Interview': 2, Onsite: 3, Offered: 4, Declined: 5 };
const interestOptions = { 'Fairy Interesting': 1, 'Quite Interesting': 2, Interesting: 3, 'Rather Interesting': 4, 'Very Interesting': 5 };

class FavoriteJobFormItem extends Component {
  constructor(props) {
    super(props);

    const { interest, remarks, status } = props;

    this.state = {
      interest,
      remarks,
      status: status || 0,
      canSubmit: false,
    };

    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleChange = this.handleChange.bind(this);
    this.handleRemove = this.handleRemove.bind(this);
  }

  handleSubmit(e) {
    e.preventDefault();
    this.props.handleUpdate(this.props.jobId, this.getUpdatedAttributes());
  }

  handleRemove() {
    this.props.handleRemove(this.props.jobId, this.props.index);
  }

  handleChange(key, value) {
    const updatedAttribute = {};
    updatedAttribute[key] = value;
    updatedAttribute.canSubmit = true;
    this.setState(updatedAttribute);
  }


  getUpdatedAttributes() {
    const attributes = {};
    if (this.props.interest !== this.state.interest) { attributes.interest = this.state.interest; }
    if (this.props.status !== this.state.status) { attributes.status = this.state.status; }
    if (this.props.remarks !== this.state.remarks) { attributes.remarks = this.state.remarks; }

    return attributes;
  }

  labelId(name) {
    return `${name}_${this.props.jobId}`;
  }

  render() {

    const { company, area, jobTitle, jobId, remarks} = this.props;

    return (
      <Wrapper>
        <Form onSubmit={this.handleSubmit}>
          <Row size="3">
            <CompanyWrapper>
              <Icon onClick={this.handleRemove}>
                <GoStar style={{ width: '100%', height: '100%' }} />
              </Icon>
              <CompanyInfo>
                <TitleLink to={`/jobs/${jobId}`}>{jobTitle}</TitleLink>
                <Info><MdLocationOn style={{ marginRight: '3px' }} />{company}</Info>
                <Info><MdLocationCity style={{ marginRight: '3px' }} />{area}</Info>
              </CompanyInfo>
            </CompanyWrapper>
          </Row>
          <Row size="2">
            <SelectField
              name="interest"
              needLabel={false}
              tabIndex={2}
              value={parseInt(this.state.interest)}
              options={interestOptions}
              handleChange={this.handleChange}
            />
          </Row>
          <Row size="2">
            <SelectField
              name="status"
              tabIndex={3}
              needLabel={false}
              value={parseInt(this.state.status)}
              options={statusOptions}
              handleChange={this.handleChange}
            />
          </Row>
          <Row size="2">
            <Textarea
              name="remarks"
              defaultValue={remarks}
              rows={3}
              onBlur={e => this.handleChange(e.target.name, e.target.value)}
            />
          </Row>
          <Row size="1">
            <UpdateButton
              type="submit"
              disabled={!this.state.canSubmit}
              tabIndex={4}
            >
              <MdSave style={{ width: '100%', height: '100%' }} />
            </UpdateButton>
          </Row>
        </Form>
      </Wrapper>
    );
  }
}

FavoriteJobFormItem.propTypes = propTypes;
export default FavoriteJobFormItem;
